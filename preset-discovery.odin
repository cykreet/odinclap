/*
   Preset Discovery API.

   Preset Discovery enables a plug-in host to identify where presets are found, what
   extensions they have, which plug-ins they apply to, and other metadata associated with the
   presets so that they can be indexed and searched for quickly within the plug-in host's browser.

   This has a number of advantages for the user:
   - it allows them to browse for presets from one central location in a consistent way
   - the user can browse for presets without having to commit to a particular plug-in first

   The API works as follow to index presets and presets metadata:
   1. clap_plugin_entry.get_factory(CLAP_PRESET_DISCOVERY_FACTORY_ID)
   2. clap_preset_discovery_factory_t.create(...)
   3. clap_preset_discovery_provider.init() (only necessary the first time, declarations
   can be cached)
        `-> clap_preset_discovery_indexer.declare_filetype()
        `-> clap_preset_discovery_indexer.declare_location()
        `-> clap_preset_discovery_indexer.declare_soundpack() (optional)
        `-> clap_preset_discovery_indexer.set_invalidation_watch_file() (optional)
   4. crawl the given locations and monitor file system changes
        `-> clap_preset_discovery_indexer.get_metadata() for each presets files

   Then to load a preset, use ext/draft/preset-load.h.
   TODO: create a dedicated repo for other plugin abi preset-load extension.

   The design of this API deliberately does not define a fixed set tags or categories. It is the
   plug-in host's job to try to intelligently map the raw list of features that are found for a
   preset and to process this list to generate something that makes sense for the host's tagging and
   categorization system. The reason for this is to reduce the work for a plug-in developer to add
   Preset Discovery support for their existing preset file format and not have to be concerned with
   all the different hosts and how they want to receive the metadata.

   VERY IMPORTANT:
   - the whole indexing process has to be **fast**
      - clap_preset_provider->get_metadata() has to be fast and avoid unnecessary operations
   - the whole indexing process must not be interactive
      - don't show dialogs, windows, ...
      - don't ask for user input
*/
package clap

clap_preset_discovery_location_kind :: enum u32 {
	// The preset are located in a file on the OS filesystem.
	// The location is then a path which works with the OS file system functions (open, stat, ...)
	// So both '/' and '\' shall work on Windows as a separator.
	FILE   = 0,

	// The preset is bundled within the plugin DSO itself.
	// The location must then be null, as the preset are within the plugin itself and then the plugin
	// will act as a preset container.
	PLUGIN = 1,
}

clap_preset_discovery_flags :: enum u32 {
	// This is for factory or sound-pack presets.
	FACTORY_CONTENT = 1,

	// This is for user presets.
	USER_CONTENT    = 2,

	// This location is meant for demo presets, those are preset which may trigger
	// some limitation in the plugin because they require additional features which the user
	// needs to purchase or the content itself needs to be bought and is only available in
	// demo mode.
	DEMO_CONTENT    = 4,

	// This preset is a user's favorite
	FAVORITE        = 8,
}

// Receiver that receives the metadata for a single preset file.
// The host would define the various callbacks in this interface and the preset parser function
// would then call them.
//
// This interface isn't thread-safe.
clap_preset_discovery_metadata_receiver :: struct {
	receiver_data: rawptr, // reserved pointer for the metadata receiver

	// If there is an error reading metadata from a file this should be called with an error
	// message.
	// os_error: the operating system error, if applicable. If not applicable set it to a non-error
	// value, eg: 0 on unix and Windows.
	on_error: proc "c" (receiver: ^clap_preset_discovery_metadata_receiver, os_error: i32, error_message: cstring),

	// This must be called for every preset in the file and before any preset metadata is
	// sent with the calls below.
	//
	// If the preset file is a preset container then name and load_key are mandatory, otherwise
	// they are optional.
	//
	// The load_key is a machine friendly string used to load the preset inside the container via a
	// the preset-load plug-in extension. The load_key can also just be the subpath if that's what
	// the plugin wants but it could also be some other unique id like a database primary key or a
	// binary offset. It's use is entirely up to the plug-in.
	//
	// If the function returns false, then the provider must stop calling back into the receiver.
	begin_preset: proc "c" (receiver: ^clap_preset_discovery_metadata_receiver, name: cstring, load_key: cstring) -> bool,

	// Adds a plug-in id that this preset can be used with.
	add_plugin_id: proc "c" (receiver: ^clap_preset_discovery_metadata_receiver, plugin_id: ^clap_universal_plugin_id_t),

	// Sets the sound pack to which the preset belongs to.
	set_soundpack_id: proc "c" (receiver: ^clap_preset_discovery_metadata_receiver, soundpack_id: cstring),

	// Sets the flags, see clap_preset_discovery_flags.
	// If unset, they are then inherited from the location.
	set_flags: proc "c" (receiver: ^clap_preset_discovery_metadata_receiver, flags: u32),

	// Adds a creator name for the preset.
	add_creator: proc "c" (receiver: ^clap_preset_discovery_metadata_receiver, creator: cstring),

	// Sets a description of the preset.
	set_description: proc "c" (receiver: ^clap_preset_discovery_metadata_receiver, description: cstring),

	// Sets the creation time and last modification time of the preset.
	// If one of the times isn't known, set it to CLAP_TIMESTAMP_UNKNOWN.
	// If this function is not called, then the indexer may look at the file's creation and
	// modification time.
	set_timestamps: proc "c" (receiver: ^clap_preset_discovery_metadata_receiver, creation_time: clap_timestamp, modification_time: clap_timestamp),

	// Adds a feature to the preset.
	//
	// The feature string is arbitrary, it is the indexer's job to understand it and remap it to its
	// internal categorization and tagging system.
	//
	// However, the strings from plugin-features.h should be understood by the indexer and one of the
	// plugin category could be provided to determine if the preset will result into an audio-effect,
	// instrument, ...
	//
	// Examples:
	// kick, drum, tom, snare, clap, cymbal, bass, lead, metalic, hardsync, crossmod, acid,
	// distorted, drone, pad, dirty, etc...
	add_feature: proc "c" (receiver: ^clap_preset_discovery_metadata_receiver, feature: cstring),

	// Adds extra information to the metadata.
	add_extra_info: proc "c" (receiver: ^clap_preset_discovery_metadata_receiver, key: cstring, value: cstring),
}

// Receiver that receives the metadata for a single preset file.
// The host would define the various callbacks in this interface and the preset parser function
// would then call them.
//
// This interface isn't thread-safe.
clap_preset_discovery_metadata_receiver_t :: clap_preset_discovery_metadata_receiver

clap_preset_discovery_filetype :: struct {
	name:        cstring,
	description: cstring, // optional

	// `.' isn't included in the string.
	// If empty or NULL then every file should be matched.
	file_extension: cstring,
}

clap_preset_discovery_filetype_t :: clap_preset_discovery_filetype

// Defines a place in which to search for presets
clap_preset_discovery_location :: struct {
	flags: u32,     // see enum clap_preset_discovery_flags
	name:  cstring, // name of this location
	kind:  u32,     // See clap_preset_discovery_location_kind

	// Actual location in which to crawl presets.
	// For FILE kind, the location can be either a path to a directory or a file.
	// For PLUGIN kind, the location must be null.
	location: cstring,
}

// Defines a place in which to search for presets
clap_preset_discovery_location_t :: clap_preset_discovery_location

// Describes an installed sound pack.
clap_preset_discovery_soundpack :: struct {
	flags:             u32,            // see enum clap_preset_discovery_flags
	id:                cstring,        // sound pack identifier
	name:              cstring,        // name of this sound pack
	description:       cstring,        // optional, reasonably short description of the sound pack
	homepage_url:      cstring,        // optional, url to the pack's homepage
	vendor:            cstring,        // optional, sound pack's vendor
	image_path:        cstring,        // optional, an image on disk
	release_timestamp: clap_timestamp, // release date, CLAP_TIMESTAMP_UNKNOWN if unavailable
}

// Describes an installed sound pack.
clap_preset_discovery_soundpack_t :: clap_preset_discovery_soundpack

// Describes a preset provider
clap_preset_discovery_provider_descriptor :: struct {
	clap_version: clap_version_t, // initialized to CLAP_VERSION
	id:           cstring,        // see plugin.h for advice on how to choose a good identifier
	name:         cstring,        // eg: "Diva's preset provider"
	vendor:       cstring,        // optional, eg: u-he
}

// Describes a preset provider
clap_preset_discovery_provider_descriptor_t :: clap_preset_discovery_provider_descriptor

// This interface isn't thread-safe.
clap_preset_discovery_provider :: struct {
	desc:          ^clap_preset_discovery_provider_descriptor_t,
	provider_data: rawptr, // reserved pointer for the provider

	// Initialize the preset provider.
	// It should declare all its locations, filetypes and sound packs.
	// Returns false if initialization failed.
	init: proc "c" (provider: ^clap_preset_discovery_provider) -> bool,

	// Destroys the preset provider
	destroy: proc "c" (provider: ^clap_preset_discovery_provider),

	// reads metadata from the given file and passes them to the metadata receiver
	// Returns true on success.
	get_metadata: proc "c" (provider: ^clap_preset_discovery_provider, location_kind: u32, location: cstring, metadata_receiver: ^clap_preset_discovery_metadata_receiver_t) -> bool,

	// Query an extension.
	// The returned pointer is owned by the provider.
	// It is forbidden to call it before provider->init().
	// You can call it within provider->init() call, and after.
	get_extension: proc "c" (provider: ^clap_preset_discovery_provider, extension_id: cstring) -> rawptr,
}

// This interface isn't thread-safe.
clap_preset_discovery_provider_t :: clap_preset_discovery_provider

// This interface isn't thread-safe
clap_preset_discovery_indexer :: struct {
	clap_version: clap_version_t, // initialized to CLAP_VERSION
	name:         cstring,        // eg: "Bitwig Studio"
	vendor:       cstring,        // optional, eg: "Bitwig GmbH"
	url:          cstring,        // optional, eg: "https://bitwig.com"
	version:      cstring,        // optional, eg: "4.3", see plugin.h for advice on how to format the version
	indexer_data: rawptr,         // reserved pointer for the indexer

	// Declares a preset filetype.
	// Don't callback into the provider during this call.
	// Returns false if the filetype is invalid.
	declare_filetype: proc "c" (indexer: ^clap_preset_discovery_indexer, filetype: ^clap_preset_discovery_filetype_t) -> bool,

	// Declares a preset location.
	// Don't callback into the provider during this call.
	// Returns false if the location is invalid.
	declare_location: proc "c" (indexer: ^clap_preset_discovery_indexer, location: ^clap_preset_discovery_location_t) -> bool,

	// Declares a sound pack.
	// Don't callback into the provider during this call.
	// Returns false if the sound pack is invalid.
	declare_soundpack: proc "c" (indexer: ^clap_preset_discovery_indexer, soundpack: ^clap_preset_discovery_soundpack_t) -> bool,

	// Query an extension.
	// The returned pointer is owned by the indexer.
	// It is forbidden to call it before provider->init().
	// You can call it within provider->init() call, and after.
	get_extension: proc "c" (indexer: ^clap_preset_discovery_indexer, extension_id: cstring) -> rawptr,
}

// This interface isn't thread-safe
clap_preset_discovery_indexer_t :: clap_preset_discovery_indexer

// Every methods in this factory must be thread-safe.
// It is encouraged to perform preset indexing in background threads, maybe even in background
// process.
//
// The host may use clap_plugin_invalidation_factory to detect filesystem changes
// which may change the factory's content.
clap_preset_discovery_factory :: struct {
	// Get the number of preset providers available.
	// [thread-safe]
	count: proc "c" (factory: ^clap_preset_discovery_factory) -> u32,

	// Retrieves a preset provider descriptor by its index.
	// Returns null in case of error.
	// The descriptor must not be freed.
	// [thread-safe]
	get_descriptor: proc "c" (factory: ^clap_preset_discovery_factory, index: u32) -> ^clap_preset_discovery_provider_descriptor_t,

	// Create a preset provider by its id.
	// The returned pointer must be freed by calling preset_provider->destroy(preset_provider);
	// The preset provider is not allowed to use the indexer callbacks in the create method.
	// It is forbidden to call back into the indexer before the indexer calls provider->init().
	// Returns null in case of error.
	// [thread-safe]
	create: proc "c" (factory: ^clap_preset_discovery_factory, indexer: ^clap_preset_discovery_indexer_t, provider_id: cstring) -> ^clap_preset_discovery_provider_t,
}

// Every methods in this factory must be thread-safe.
// It is encouraged to perform preset indexing in background threads, maybe even in background
// process.
//
// The host may use clap_plugin_invalidation_factory to detect filesystem changes
// which may change the factory's content.
clap_preset_discovery_factory_t :: clap_preset_discovery_factory

// Use it to retrieve const clap_preset_discovery_factory_t* from
// clap_plugin_entry.get_factory()
CLAP_PRESET_DISCOVERY_FACTORY_ID: cstring		= "clap.preset-discovery-factory/2"

// The latest draft is 100% compatible.
// This compat ID may be removed in 2026.
CLAP_PRESET_DISCOVERY_FACTORY_ID_COMPAT: cstring	= "clap.preset-discovery-factory/draft-2"
