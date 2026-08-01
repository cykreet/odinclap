package clap

CLAP_VOICE_INFO_SUPPORTS_OVERLAPPING_NOTES :: 1

clap_voice_info :: struct {
	// voice_count is the current number of voices that the patch can use
	// voice_capacity is the number of voices allocated voices
	// voice_count should not be confused with the number of active voices.
	//
	// 1 <= voice_count <= voice_capacity
	//
	// For example, a synth can have a capacity of 8 voices, but be configured
	// to only use 4 voices: {count: 4, capacity: 8}.
	//
	// If the voice_count is 1, then the synth is working in mono and the host
	// can decide to only use global modulation mapping.
	voice_count:    u32,
	voice_capacity: u32,
	flags:          u64,
}

clap_voice_info_t :: clap_voice_info

clap_plugin_voice_info :: struct {
	// gets the voice info, returns true on success
	// [main-thread & active]
	get: proc "c" (plugin: ^clap_plugin_t, info: ^clap_voice_info_t) -> bool,
}

clap_plugin_voice_info_t :: clap_plugin_voice_info

clap_host_voice_info :: struct {
	// informs the host that the voice info has changed
	// [main-thread]
	changed: proc "c" (host: ^clap_host_t),
}

clap_host_voice_info_t :: clap_host_voice_info

