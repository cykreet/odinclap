package ext

import ".."


clap_plugin_preset_load :: struct {
	// Loads a preset in the plugin native preset file format from a location.
	// The preset discovery provider defines the location and load_key to be passed to this function.
	// Returns true on success.
	// [main-thread]
	from_location: proc "c" (plugin: ^clap_plugin_t, location_kind: u32, location: cstring, load_key: cstring) -> bool,
}

clap_plugin_preset_load_t :: clap_plugin_preset_load

clap_host_preset_load :: struct {
	// Called if clap_plugin_preset_load.from_location() failed.
	// os_error: the operating system error, if applicable. If not applicable set it to a non-error
	// value, eg: 0 on unix and Windows.
	//
	// [main-thread]
	on_error: proc "c" (host: ^clap_host_t, location_kind: u32, location: cstring, load_key: cstring, os_error: i32, msg: cstring),

	// Informs the host that the following preset has been loaded.
	// This contributes to keep in sync the host preset browser and plugin preset browser.
	// If the preset was loaded from a container file, then the load_key must be set, otherwise it
	// must be null.
	//
	// [main-thread]
	loaded: proc "c" (host: ^clap_host_t, location_kind: u32, location: cstring, load_key: cstring),
}

clap_host_preset_load_t :: clap_host_preset_load

CLAP_EXT_PRESET_LOAD: cstring			: "clap.preset-load/2"
CLAP_EXT_PRESET_LOAD_COMPAT: cstring	: "clap-preset.draft/2"
