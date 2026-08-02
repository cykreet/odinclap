package clap

import "core:c"

clap_hwnd   :: rawptr
clap_nsview :: rawptr
clap_uiview :: rawptr
clap_xwnd   :: c.ulong

// Represent a window reference.
clap_window :: struct {
	api: cstring, // one of CLAP_WINDOW_API_XXX

	using _: struct #raw_union {
		cocoa: clap_nsview,
		uikit: clap_uiview,
		x11:   clap_xwnd,
		win32: clap_hwnd,
		ptr:   rawptr, // for anything defined outside of clap
	},
}

// Represent a window reference.
clap_window_t :: clap_window

// Information to improve window resizing when initiated by the host or window manager.
clap_gui_resize_hints :: struct {
	can_resize_horizontally: bool,
	can_resize_vertically:   bool,

	// if both horizontal and vertical resize are available, do we preserve the
	// aspect ratio, and if so, what is the width x height aspect ratio to preserve.
	// These flags are unused if can_resize_horizontally or vertically are false,
	// and ratios are unused if preserve is false.
	preserve_aspect_ratio: bool,
	aspect_ratio_width:    u32,
	aspect_ratio_height:   u32,
}

// Information to improve window resizing when initiated by the host or window manager.
clap_gui_resize_hints_t :: clap_gui_resize_hints

// Size (width, height) is in pixels; the corresponding windowing system extension is
// responsible for defining if it is physical pixels or logical pixels.
clap_plugin_gui :: struct {
	// Returns true if the requested gui api is supported, either in floating (plugin-created)
	// or non-floating (embedded) mode.
	// [main-thread]
	is_api_supported: proc "c" (plugin: ^clap_plugin_t, api: cstring, is_floating: bool) -> bool,

	// Returns true if the plugin has a preferred api.
	// The host has no obligation to honor the plugin preference, this is just a hint.
	// The const char **api variable should be explicitly assigned as a pointer to
	// one of the CLAP_WINDOW_API_ constants defined above, not strcopied.
	// [main-thread]
	get_preferred_api: proc "c" (plugin: ^clap_plugin_t, api: ^cstring, is_floating: ^bool) -> bool,

	// Create and allocate all resources necessary for the gui.
	//
	// If is_floating is true, then the window will not be managed by the host. The plugin
	// can set its window to stays above the parent window, see set_transient().
	// api may be null or blank for floating window.
	//
	// If is_floating is false, then the plugin has to embed its window into the parent window, see
	// set_parent().
	//
	// After this call, the GUI may not be visible yet; don't forget to call show().
	//
	// Returns true if the GUI is successfully created.
	// [main-thread]
	create: proc "c" (plugin: ^clap_plugin_t, api: cstring, is_floating: bool) -> bool,

	// Free all resources associated with the gui.
	// [main-thread]
	destroy: proc "c" (plugin: ^clap_plugin_t),

	// Set the absolute GUI scaling factor, and override any OS info.
	// Should not be used if the windowing api relies upon logical pixels.
	//
	// If the plugin prefers to work out the scaling factor itself by querying the OS directly,
	// then ignore the call.
	//
	// scale = 2 means 200% scaling.
	//
	// Returns true if the scaling could be applied
	// Returns false if the call was ignored, or the scaling could not be applied.
	// [main-thread]
	set_scale: proc "c" (plugin: ^clap_plugin_t, scale: f64) -> bool,

	// Get the current size of the plugin UI.
	// clap_plugin_gui->create() must have been called prior to asking the size.
	//
	// Returns true if the plugin could get the size.
	// [main-thread]
	get_size: proc "c" (plugin: ^clap_plugin_t, width: ^u32, height: ^u32) -> bool,

	// Returns true if the window is resizeable (mouse drag).
	// [main-thread & !floating]
	can_resize: proc "c" (plugin: ^clap_plugin_t) -> bool,

	// Returns true if the plugin can provide hints on how to resize the window.
	// [main-thread & !floating]
	get_resize_hints: proc "c" (plugin: ^clap_plugin_t, hints: ^clap_gui_resize_hints_t) -> bool,

	// If the plugin gui is resizable, then the plugin will calculate the closest
	// usable size which fits in the given size.
	// This method does not change the size.
	//
	// Returns true if the plugin could adjust the given size.
	// [main-thread & !floating]
	adjust_size: proc "c" (plugin: ^clap_plugin_t, width: ^u32, height: ^u32) -> bool,

	// Sets the window size.
	//
	// Returns true if the plugin could resize its window to the given size.
	// [main-thread & !floating]
	set_size: proc "c" (plugin: ^clap_plugin_t, width: u32, height: u32) -> bool,

	// Embeds the plugin window into the given window.
	//
	// Returns true on success.
	// [main-thread & !floating]
	set_parent: proc "c" (plugin: ^clap_plugin_t, window: ^clap_window_t) -> bool,

	// Set the plugin floating window to stay above the given window.
	//
	// Returns true on success.
	// [main-thread & floating]
	set_transient: proc "c" (plugin: ^clap_plugin_t, window: ^clap_window_t) -> bool,

	// Suggests a window title. Only for floating windows.
	//
	// [main-thread & floating]
	suggest_title: proc "c" (plugin: ^clap_plugin_t, title: cstring),

	// Show the window.
	//
	// Returns true on success.
	// [main-thread]
	show: proc "c" (plugin: ^clap_plugin_t) -> bool,

	// Hide the window, this method does not free the resources, it just hides
	// the window content. Yet it may be a good idea to stop painting timers.
	//
	// Returns true on success.
	// [main-thread]
	hide: proc "c" (plugin: ^clap_plugin_t) -> bool,
}

// Size (width, height) is in pixels; the corresponding windowing system extension is
// responsible for defining if it is physical pixels or logical pixels.
clap_plugin_gui_t :: clap_plugin_gui

clap_host_gui :: struct {
	// The host should call get_resize_hints() again.
	// [thread-safe & !floating]
	resize_hints_changed: proc "c" (host: ^clap_host_t),

	// Request the host to resize the client area to width, height.
	// Return true if the new size is accepted, false otherwise.
	// The host doesn't have to call set_size().
	//
	// Note: if not called from the main thread, then a return value simply means that the host
	// acknowledged the request and will process it asynchronously. If the request then can't be
	// satisfied then the host will call set_size() to revert the operation.
	// [thread-safe & !floating]
	request_resize: proc "c" (host: ^clap_host_t, width: u32, height: u32) -> bool,

	// Request the host to show the plugin gui.
	// Return true on success, false otherwise.
	// [thread-safe]
	request_show: proc "c" (host: ^clap_host_t) -> bool,

	// Request the host to hide the plugin gui.
	// Return true on success, false otherwise.
	// [thread-safe]
	request_hide: proc "c" (host: ^clap_host_t) -> bool,

	// The floating window has been closed, or the connection to the gui has been lost.
	//
	// If was_destroyed is true, then the host must call clap_plugin_gui->destroy() to acknowledge
	// the gui destruction.
	// [thread-safe]
	closed: proc "c" (host: ^clap_host_t, was_destroyed: bool),
}

clap_host_gui_t :: clap_host_gui

