package draft

imports "../.."


clap_plugin_background_state_context :: struct {
	// Same as clap_plugin_state_context.save() but it is called from a background thread.
	// See clap_host_background_progress for progress feedback and cancelation.
	// [background-thread]
	save_from_background_thread: proc "c" (plugin: ^clap_plugin_t, stream: ^clap_ostream_t, context_type: u32) -> bool,

	// Same as clap_plugin_state_context.load() but it is called from a background thread.
	// See clap_host_background_progress for progress feedback and cancelation.
	// [background-thread]
	load_from_background_thread: proc "c" (plugin: ^clap_plugin_t, stream: ^clap_istream_t, context_type: u32) -> bool,
}

clap_plugin_background_state_context_t :: clap_plugin_background_state_context

CLAP_EXT_BACKGROUND_STATE_CONTEXT: cstring : "clap.background-state-context/1"
