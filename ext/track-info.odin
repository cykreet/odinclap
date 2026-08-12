package ext

import ".."


CLAP_TRACK_INFO_HAS_TRACK_NAME      :: 1
CLAP_TRACK_INFO_HAS_TRACK_COLOR     :: 2
CLAP_TRACK_INFO_HAS_AUDIO_CHANNEL   :: 4
CLAP_TRACK_INFO_IS_FOR_RETURN_TRACK :: 8
CLAP_TRACK_INFO_IS_FOR_BUS          :: 16
CLAP_TRACK_INFO_IS_FOR_MASTER       :: 32

clap_track_info :: struct {
	flags: u64, // see the flags above

	// track name, available if flags contain CLAP_TRACK_INFO_HAS_TRACK_NAME
	name: [256]i8,

	// track color, available if flags contain CLAP_TRACK_INFO_HAS_TRACK_COLOR
	color: clap_color_t,

	// available if flags contain CLAP_TRACK_INFO_HAS_AUDIO_CHANNEL
	// see audio-ports.h, struct clap_audio_port_info to learn how to use channel count and port type
	audio_channel_count: i32,
	audio_port_type:     cstring,
}

clap_track_info_t :: clap_track_info

clap_plugin_track_info :: struct {
	// Called when the info changes.
	// [main-thread]
	changed: proc "c" (plugin: ^clap_plugin_t),
}

clap_plugin_track_info_t :: clap_plugin_track_info

clap_host_track_info :: struct {
	// Get info about the track the plugin belongs to.
	// Returns true on success and stores the result into info.
	// [main-thread]
	get: proc "c" (host: ^clap_host_t, info: ^clap_track_info_t) -> bool,
}

clap_host_track_info_t :: clap_host_track_info

CLAP_EXT_TRACK_INFO: cstring		: "clap.track-info/1"
CLAP_EXT_TRACK_INFO_COMPAT: cstring	: "clap.track-info.draft/1"
