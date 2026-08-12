package ext

import ".."


clap_plugin_latency :: struct {
	// Returns the plugin latency in samples.
	// [main-thread & (being-activated | active)]
	get: proc "c" (plugin: ^clap_plugin_t) -> u32,
}

clap_plugin_latency_t :: clap_plugin_latency

clap_host_latency :: struct {
	// Tell the host that the latency changed.
	// The latency is only allowed to change during plugin->activate.
	// If the plugin is activated, call host->request_restart()
	// [main-thread & being-activated]
	changed: proc "c" (host: ^clap_host_t),
}

clap_host_latency_t :: clap_host_latency

CLAP_EXT_LATENCY: cstring : "clap.latency"
