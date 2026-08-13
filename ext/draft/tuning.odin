package draft

imports "../.."


// Use clap_host_event_registry->query(host, CLAP_EXT_TUNING, &space_id) to know the event space.
//
// This event defines the tuning to be used on the given port/channel.
clap_event_tuning :: struct {
	header:     clap_event_header_t,
	port_index: i16, // -1 global
	channel:    i16, // 0..15, -1 global
	tunning_id: clap_id,
}

// Use clap_host_event_registry->query(host, CLAP_EXT_TUNING, &space_id) to know the event space.
//
// This event defines the tuning to be used on the given port/channel.
clap_event_tuning_t :: clap_event_tuning

clap_tuning_info :: struct {
	tuning_id:  clap_id,
	name:       [256]i8,
	is_dynamic: bool, // true if the values may vary with time
}

clap_tuning_info_t :: clap_tuning_info

clap_plugin_tuning :: struct {
	// Called when a tuning is added or removed from the pool.
	// [main-thread]
	changed: proc "c" (plugin: ^clap_plugin_t),
}

clap_plugin_tuning_t :: clap_plugin_tuning

// This extension provides a dynamic tuning table to the plugin.
clap_host_tuning :: struct {
	// Gets the relative tuning in semitones against equal temperament with A4=440Hz.
	// The plugin may query the tuning at a rate that makes sense for *low* frequency modulations.
	//
	// If the tuning_id is not found or equals to CLAP_INVALID_ID,
	// then the function shall gracefully return a sensible value.
	//
	// sample_offset is the sample offset from the beginning of the current process block.
	//
	// should_play(...) should be checked before calling this function.
	//
	// [audio-thread & in-process]
	get_relative: proc "c" (host: ^clap_host_t, tuning_id: clap_id, channel: i32, key: i32, sample_offset: u32) -> f64,

	// Returns true if the note should be played.
	// [audio-thread & in-process]
	should_play: proc "c" (host: ^clap_host_t, tuning_id: clap_id, channel: i32, key: i32) -> bool,

	// Returns the number of tunings in the pool.
	// [main-thread]
	get_tuning_count: proc "c" (host: ^clap_host_t) -> u32,

	// Gets info about a tuning
	// Returns true on success and stores the result into info.
	// [main-thread]
	get_info: proc "c" (host: ^clap_host_t, tuning_index: u32, info: ^clap_tuning_info_t) -> bool,
}

// This extension provides a dynamic tuning table to the plugin.
clap_host_tuning_t :: clap_host_tuning

CLAP_EXT_TUNING: cstring : "clap.tuning/2"
