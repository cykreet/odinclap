package ext

import ".."


CLAP_AUDIO_PORT_IS_MAIN                     :: 1
CLAP_AUDIO_PORT_SUPPORTS_64BITS             :: 2
CLAP_AUDIO_PORT_PREFERS_64BITS              :: 4
CLAP_AUDIO_PORT_REQUIRES_COMMON_SAMPLE_SIZE :: 8

clap_audio_port_info :: struct {
	// id identifies a port and must be stable.
	// id may overlap between input and output ports.
	id:            clap_id,
	name:          [256]i8, // displayable name
	flags:         u32,
	channel_count: u32,

	// If null or empty then it is unspecified (arbitrary audio).
	// This field can be compared against:
	// - CLAP_PORT_MONO
	// - CLAP_PORT_STEREO
	// - CLAP_PORT_SURROUND (defined in the surround extension)
	// - CLAP_PORT_AMBISONIC (defined in the ambisonic extension)
	//
	// An extension can provide its own port type and way to inspect the channels.
	port_type: cstring,

	// in-place processing: allow the host to use the same buffer for input and output
	// if supported set the pair port id.
	// if not supported set to CLAP_INVALID_ID
	in_place_pair: clap_id,
}

clap_audio_port_info_t :: clap_audio_port_info

// The audio ports scan has to be done while the plugin is deactivated.
clap_plugin_audio_ports :: struct {
	// Number of ports, for either input or output
	// [main-thread]
	count: proc "c" (plugin: ^clap_plugin_t, is_input: bool) -> u32,

	// Get info about an audio port.
	// Returns true on success and stores the result into info.
	// [main-thread]
	get: proc "c" (plugin: ^clap_plugin_t, index: u32, is_input: bool, info: ^clap_audio_port_info_t) -> bool,
}

// The audio ports scan has to be done while the plugin is deactivated.
clap_plugin_audio_ports_t :: clap_plugin_audio_ports

CLAP_AUDIO_PORTS_RESCAN_NAMES         :: 1
CLAP_AUDIO_PORTS_RESCAN_FLAGS         :: 2
CLAP_AUDIO_PORTS_RESCAN_CHANNEL_COUNT :: 4
CLAP_AUDIO_PORTS_RESCAN_PORT_TYPE     :: 8
CLAP_AUDIO_PORTS_RESCAN_IN_PLACE_PAIR :: 16
CLAP_AUDIO_PORTS_RESCAN_LIST          :: 32

clap_host_audio_ports :: struct {
	// Checks if the host allows a plugin to change a given aspect of the audio ports definition.
	// [main-thread]
	is_rescan_flag_supported: proc "c" (host: ^clap_host_t, flag: u32) -> bool,

	// Rescan the full list of audio ports according to the flags.
	// It is illegal to ask the host to rescan with a flag that is not supported.
	// Certain flags require the plugin to be de-activated.
	// [main-thread]
	rescan: proc "c" (host: ^clap_host_t, flags: u32),
}

clap_host_audio_ports_t :: clap_host_audio_ports

CLAP_EXT_AUDIO_PORTS: cstring	: "clap.audio-ports"
CLAP_PORT_MONO: cstring		: "mono"
CLAP_PORT_STEREO: cstring	: "stereo"	
