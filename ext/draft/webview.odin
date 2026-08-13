package draft

imports "../.."


/// @page Webview
///
/// This extension enables the plugin to provide the start-page for a webview UI, and exchange
/// messages back and forth.
///
/// Messages are received in the webview using a standard MessageEvent, with the data in an
/// ArrayBuffer. They are posted back to the plugin using window.parent.postMessage(), with the
/// data in an ArrayBuffer or TypedArray.
clap_plugin_webview :: struct {
	// Writes the URL for the webview's initial navigation to the provided `uri` buffer as a
	// null-terminated UTF-8 string.
	//
	// This must be called at least once before any messages are sent (or accepted) by the host.
	// Absolute URIs (including `data:`, and `file:` URIs on local systems) are always supported.
	// Relative URIs (with absolute paths) refer to resources provided by .get_resource(), which
	// may be provided to the webview with an arbitrary scheme or URI prefix. The host may also
	// translate `file:` URIs to some other scheme or path root, to limit access scope or handle
	// virtual filesystems. Therefore, when using either relative or `file:` URIs, pages must not
	// assume a particular absolute path, only relative paths between resources.
	//
	// Returns either the full length of the URI (including the null terminator), or <= 0 for an
	// error. If the value returned is greater than the capacity, then the result was truncated.
	// If the capacity is 0, `uri` may be a null pointer. In this case, the length of the URI is
	// returned without writing to `uri`, allowing the host to preallocate a buffer for a subsequent
	// call.
	// [main-thread]
	get_uri: proc "c" (plugin: ^clap_plugin_t, uri: cstring, uri_capacity: u32) -> i32,

	//
	// [main-thread]
	get_resource: proc "c" (plugin: ^clap_plugin_t, path: cstring, mime: cstring, mime_capacity: u32, data_stream: ^clap_ostream_t) -> bool,

	// Receives a single message from the webview, which must be open and ready to receive replies.
	// Returns true on success.
	// [main-thread]
	receive: proc "c" (plugin: ^clap_plugin_t, buffer: rawptr, size: u32) -> bool,
}

/// @page Webview
///
/// This extension enables the plugin to provide the start-page for a webview UI, and exchange
/// messages back and forth.
///
/// Messages are received in the webview using a standard MessageEvent, with the data in an
/// ArrayBuffer. They are posted back to the plugin using window.parent.postMessage(), with the
/// data in an ArrayBuffer or TypedArray.
clap_plugin_webview_t :: clap_plugin_webview

clap_host_webview :: struct {
	// Sends a single message to the webview.
	// Returns true on success. It must fail (false) if the webview is not open.
	// [main-thread]
	send: proc "c" (host: ^clap_host_t, buffer: rawptr, size: u32) -> bool,
}

clap_host_webview_t :: clap_host_webview

CLAP_EXT_WEBVIEW: cstring			: "clap.webview/3"
CLAP_WINDOW_API_WEBVIEW: cstring	: "webview"
