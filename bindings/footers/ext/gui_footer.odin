CLAP_EXT_GUI: cstring				: "clap.gui"

// If your windowing API is not listed here, please open an issue and we'll figure it out.
// https://github.com/free-audio/clap/issues/new

// uses physical size
// embed using https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setparent
CLAP_WINDOW_API_WIN32: cstring		: "win32"

// uses logical size, don't call clap_plugin_gui->set_scale()
CLAP_WINDOW_API_COCOA: cstring		: "cocoa"

// uses logical size, don't call clap_plugin_gui->set_scale()
CLAP_WINDOW_API_UIKIT: cstring		: "uikit"

// uses physical size
// embed using https://specifications.freedesktop.org/xembed-spec/xembed-spec-latest.html
CLAP_WINDOW_API_X11: cstring		: "x11"

// uses physical size
// embed is currently not supported, use floating windows
CLAP_WINDOW_API_WAYLAND: cstring	:"wayland"
