package ext

import ".."


CLAP_RENDER_REALTIME :: 0
CLAP_RENDER_OFFLINE  :: 1

clap_plugin_render_mode :: i32

// The render extension is used to let the plugin know if it has "realtime"
// pressure to process.
//
// If this information does not influence your rendering code, then don't
// implement this extension.
clap_plugin_render :: struct {
	// Returns true if the plugin has a hard requirement to process in real-time.
	// This is especially useful for plugin acting as a proxy to an hardware device.
	// [main-thread]
	has_hard_realtime_requirement: proc "c" (plugin: ^clap_plugin_t) -> bool,

	// Returns true if the rendering mode could be applied.
	// [main-thread]
	set: proc "c" (plugin: ^clap_plugin_t, mode: clap_plugin_render_mode) -> bool,
}

// The render extension is used to let the plugin know if it has "realtime"
// pressure to process.
//
// If this information does not influence your rendering code, then don't
// implement this extension.
clap_plugin_render_t :: clap_plugin_render

CLAP_EXT_RENDER: cstring : "clap.render"
