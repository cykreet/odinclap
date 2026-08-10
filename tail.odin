package clap

clap_plugin_tail :: struct {
	// Returns tail length in samples.
	// Any value greater or equal to INT32_MAX implies infinite tail.
	// [main-thread,audio-thread]
	get: proc "c" (plugin: ^clap_plugin_t) -> u32,
}

clap_plugin_tail_t :: clap_plugin_tail

clap_host_tail :: struct {
	// Tell the host that the tail has changed.
	// [audio-thread]
	changed: proc "c" (host: ^clap_host_t),
}

clap_host_tail_t :: clap_host_tail

