package ext

import ".."


CLAP_SURROUND_FL  :: 0
CLAP_SURROUND_FR  :: 1
CLAP_SURROUND_FC  :: 2
CLAP_SURROUND_LFE :: 3
CLAP_SURROUND_BL  :: 4
CLAP_SURROUND_BR  :: 5
CLAP_SURROUND_FLC :: 6
CLAP_SURROUND_FRC :: 7
CLAP_SURROUND_BC  :: 8
CLAP_SURROUND_SL  :: 9
CLAP_SURROUND_SR  :: 10
CLAP_SURROUND_TC  :: 11
CLAP_SURROUND_TFL :: 12
CLAP_SURROUND_TFC :: 13
CLAP_SURROUND_TFR :: 14
CLAP_SURROUND_TBL :: 15
CLAP_SURROUND_TBC :: 16
CLAP_SURROUND_TBR :: 17
CLAP_SURROUND_TSL :: 18
CLAP_SURROUND_TSR :: 19

clap_plugin_surround :: struct {
	// Checks if a given channel mask is supported.
	// The channel mask is a bitmask, for example:
	//   (1 << CLAP_SURROUND_FL) | (1 << CLAP_SURROUND_FR) | ...
	// [main-thread]
	is_channel_mask_supported: proc "c" (plugin: ^clap_plugin_t, channel_mask: u64) -> bool,

	// Stores the surround identifier of each channel into the channel_map array.
	// Returns the number of elements stored in channel_map.
	// channel_map_capacity must be greater or equal to the channel count of the given port.
	// [main-thread]
	get_channel_map: proc "c" (plugin: ^clap_plugin_t, is_input: bool, port_index: u32, channel_map: ^u8, channel_map_capacity: u32) -> u32,
}

clap_plugin_surround_t :: clap_plugin_surround

clap_host_surround :: struct {
	// Informs the host that the channel map has changed.
	// The channel map can only change when the plugin is de-activated.
	// [main-thread]
	changed: proc "c" (host: ^clap_host_t),
}

clap_host_surround_t :: clap_host_surround

CLAP_EXT_SURROUND: cstring			: "clap.surround/4"
CLAP_EXT_SURROUND_COMPAT: cstring	: "clap.surround.draft/4"
CLAP_PORT_SURROUND: cstring			: "surround"
