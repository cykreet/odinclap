package draft

imports "../.."


clap_plugin_flush_events :: struct {
	// Flushes a set of events.
	// This method must not be called concurrently to clap_plugin->process().
	//
	// Note: if the plugin is processing, then the process() call will already perform events I/O, so
	// a call to flush isn't required, also be aware that the plugin may use the sample offset in
	// process(), while this information would be lost within flush().
	//
	// [active ? audio-thread : main-thread]
	flush: proc "c" (plugin: ^clap_plugin_t, _in: ^clap_input_events_t, out: ^clap_output_events_t),
}

clap_plugin_flush_events_t :: clap_plugin_flush_events

clap_host_flush_events :: struct {
	// Request an event flush.
	//
	// The host will then schedule a call to either:
	// - clap_plugin.process()
	// - clap_plugin_flush_events.flush()
	//
	// This function is always safe to use and should not be called from an [audio-thread] as the
	// plugin would already be within process() or flush().
	//
	// [thread-safe,!audio-thread]
	request_flush: proc "c" (host: ^clap_host_t),
}

clap_host_flush_events_t :: clap_host_flush_events

CLAP_EXT_FLUSH_EVENTS: cstring : "clap.flush-events/1"
