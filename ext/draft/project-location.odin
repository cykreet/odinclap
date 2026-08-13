package draft

imports "../.."


clap_project_location_kind :: enum u32 {
	// Represents a document/project/session.
	PROJECT             = 1,

	// Represents a group of tracks.
	// It can contain track groups, tracks, and devices (post processing).
	// The first device within a track group has the index of
	// the last track or track group within this group + 1.
	TRACK_GROUP         = 2,

	// Represents a single track.
	// It contains devices (serial).
	TRACK               = 3,

	// Represents a single device.
	// It can contain other nested device chains.
	DEVICE              = 4,

	// Represents a nested device chain (serial).
	// Its parent must be a device.
	// It contains other devices.
	NESTED_DEVICE_CHAIN = 5,
}

clap_project_location_track_kind :: enum u32 {
	// This track is an instrument track.
	INSTUMENT_TRACK = 1,

	// This track is an audio track.
	AUDIO_TRACK     = 2,

	// This track is both an instrument and audio track.
	HYBRID_TRACK    = 3,

	// This track is a return track.
	RETURN_TRACK    = 4,

	// This track is a master track.
	// Each group have a master track for processing the sum of all its children tracks.
	MASTER_TRACK    = 5,
}

clap_project_location_flags :: enum u32 {
	INDEX = 1,
	COLOR = 2,
}

clap_project_location_element :: struct {
	// A bit-mask, see clap_project_location_flags.
	flags: u64,

	// Kind of the element, must be one of the CLAP_PROJECT_LOCATION_* values.
	kind: u32,

	// Only relevant if kind is CLAP_PLUGIN_LOCATION_TRACK.
	// see enum CLAP_PROJECT_LOCATION_track_kind.
	track_kind: u32,

	// Index within the parent element.
	// Only usable if CLAP_PROJECT_LOCATION_HAS_INDEX is set in flags.
	index: u32,

	// Internal ID of the element.
	// This is not intended for display to the user,
	// but rather to give the host a potential quick way for lookups.
	id: [1024]i8,

	// User friendly name of the element.
	name: [256]i8,

	// Color for this element.
	// Only usable if CLAP_PROJECT_LOCATION_HAS_COLOR is set in flags.
	color: clap_color_t,
}

clap_project_location_element_t :: clap_project_location_element

clap_plugin_project_location :: struct {
	// Called by the host when the location of the plugin instance changes.
	//
	// The last item in this array always refers to the device itself, and as
	// such is expected to be of kind CLAP_PLUGIN_LOCATION_DEVICE.
	// The first item in this array always refers to the project this device is in and must be of
	// kind CLAP_PROJECT_LOCATION_PROJECT. The path is expected to be something like: PROJECT >
	// TRACK_GROUP+ > TRACK > (DEVICE > NESTED_DEVICE_CHAIN)* > DEVICE
	//
	// [main-thread]
	set: proc "c" (plugin: ^clap_plugin_t, path: ^clap_project_location_element_t, num_elements: u32),
}

clap_plugin_project_location_t :: clap_plugin_project_location

CLAP_EXT_PROJECT_LOCATION: cstring : "clap.project-location/2"
