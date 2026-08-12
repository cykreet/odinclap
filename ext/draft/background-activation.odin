package draft

imports "../.."


clap_plugin_background_activation :: struct {
	// Same as clap_plugin.activate() but it is called from a background thread.
	// See clap_host_background_progress for progress feedback and cancelation.
	//
	// [background-thread]
	activate_from_background_thread: proc "c" (plugin: ^clap_plugin_t, sample_rate: f64, min_frames_count: u32, max_frames_count: u32) -> bool,

	// Same as clap_plugin.deactivate() but it is called from a background thread.
	// See clap_host_background_progress for progress feedback and cancelation.
	//
	// [background-thread]
	deactivate_from_background_thread: proc "c" (plugin: ^clap_plugin),
}

clap_plugin_background_activation_t :: clap_plugin_background_activation

CLAP_EXT_BACKGROUND_ACTIVATION: cstring : "clap.background-activation/1"
