package clap

clap_plugin_state :: struct {
	// Saves the plugin state into stream.
	// Returns true if the state was correctly saved.
	// [main-thread]
	save: proc "c" (plugin: ^clap_plugin_t, stream: ^clap_ostream_t) -> bool,

	// Loads the plugin state from stream.
	// Returns true if the state was correctly restored.
	// [main-thread]
	load: proc "c" (plugin: ^clap_plugin_t, stream: ^clap_istream_t) -> bool,
}

clap_plugin_state_t :: clap_plugin_state

clap_host_state :: struct {
	// Tell the host that the plugin state has changed and should be saved again.
	// If a parameter value changes, then it is implicit that the state is dirty.
	// [main-thread]
	mark_dirty: proc "c" (host: ^clap_host_t),
}

clap_host_state_t :: clap_host_state

