package draft

imports "../.."


clap_mini_curve_display_curve_kind :: enum u32 {
	// If the curve's kind doesn't fit in any proposed kind, use this one
	// and perhaps, make a pull request to extend the list.
	UNSPECIFIED    = 0,

	// The mini curve is intended to draw the total gain response of the plugin.
	// In this case the y values are in dB and the x values are in Hz (logarithmic).
	// This would be useful in for example an equalizer.
	GAIN_RESPONSE  = 1,

	// The mini curve is intended to draw the total phase response of the plugin.
	// In this case the y values are in radians and the x values are in Hz (logarithmic).
	// This would be useful in for example an equalizer.
	PHASE_RESPONSE = 2,

	// The mini curve is intended to draw the transfer curve of the plugin.
	// In this case the both x and y values are in dB.
	// This would be useful in for example a compressor or distortion plugin.
	TRANSFER_CURVE = 3,

	// This mini curve is intended to draw gain reduction over time. In this case
	// x refers to the window in seconds and y refers to level in dB, x_min is
	// always 0, and x_max would be the duration of the window.
	// This would be useful in for example a compressor or limiter.
	GAIN_REDUCTION = 4,

	// This curve is intended as a generic time series plot. In this case
	// x refers to the window in seconds. x_min is always 0, and x_max would be the duration of the
	// window.
	// Y is not specified and up to the plugin.
	TIME_SERIES    = 5,
}

clap_mini_curve_display_curve_hints :: struct {
	// Range for the x axis.
	x_min: f64,
	x_max: f64,

	// Range for the y axis.
	y_min: f64,
	y_max: f64,
}

clap_mini_curve_display_curve_hints_t :: clap_mini_curve_display_curve_hints

// A set of points representing the curve to be painted.
clap_mini_curve_display_curve_data :: struct {
	// Indicates the kind of curve those values represent, the host can use this
	// information to paint the curve using a meaningful color.
	curve_kind: i32,

	// values[0] will be the leftmost value and values[data_size -1] will be the rightmost
	// value.
	//
	// The value 0 and UINT16_MAX won't be painted.
	// The value 1 will be at the bottom of the curve and UINT16_MAX - 1 will be at the top.
	values:       ^u16,
	values_count: u32,
}

// A set of points representing the curve to be painted.
clap_mini_curve_display_curve_data_t :: clap_mini_curve_display_curve_data

clap_plugin_mini_curve_display :: struct {
	// Returns the number of curves the plugin wants to paint.
	// Be aware that the space to display those curves will be small, and too much data will make
	// the output hard to read.
	get_curve_count: proc "c" (plugin: ^clap_plugin_t) -> u32,

	// Renders the curve into each the curves buffer.
	//
	// curves is an array, and each entries (up to curves_size) contains pre-allocated
	// values buffer that must be filled by the plugin.
	//
	// The host will "stack" the curves, from the first one to the last one.
	// curves[0] is the first curve to be painted.
	// curves[n + 1] will be painted over curves[n].
	//
	// Returns the number of curves rendered.
	// [main-thread]
	render: proc "c" (plugin: ^clap_plugin_t, curves: ^clap_mini_curve_display_curve_data_t, curves_size: u32) -> u32,

	// Tells the plugin if the curve is currently observed or not.
	// When it isn't observed render() can't be called.
	//
	// When is_obseverd becomes true, the curve content and axis name are implicitly invalidated. So
	// the plugin don't need to call host->changed.
	//
	// [main-thread]
	set_observed: proc "c" (plugin: ^clap_plugin_t, is_observed: bool),

	// Retrives the axis name.
	// x_name and y_name must not to be null.
	// Returns true on success, if the name capacity was sufficient.
	// [main-thread]
	get_axis_name: proc "c" (plugin: ^clap_plugin_t, curve_index: u32, x_name: cstring, y_name: cstring, name_capacity: u32) -> bool,
}

clap_plugin_mini_curve_display_t :: clap_plugin_mini_curve_display

clap_mini_curve_display_change_flags :: enum u32 {
	// Informs the host that the curve content changed.
	// Can only be called if the curve is observed and is static.
	CURVE_CHANGED     = 1,

	// Informs the host that the curve axis name changed.
	// Can only be called if the curve is observed.
	AXIS_NAME_CHANGED = 2,
}

clap_host_mini_curve_display :: struct {
	// Fills in the given clap_mini_display_curve_hints_t structure and returns
	// true if successful. If not, return false.
	// [main-thread]
	get_hints: proc "c" (host: ^clap_host_t, kind: u32, hints: ^clap_mini_curve_display_curve_hints_t) -> bool,

	// Mark the curve as being static or dynamic.
	// The curve is initially considered as static, though the plugin should explicitely
	// initialize this state.
	//
	// When static, the curve changes will be notified by calling host->changed().
	// When dynamic, the curve is constantly changing and the host is expected to
	// periodically re-render.
	//
	// [main-thread]
	set_dynamic: proc "c" (host: ^clap_host_t, is_dynamic: bool),

	// See clap_mini_curve_display_change_flags
	// [main-thread]
	changed: proc "c" (host: ^clap_host_t, flags: u32),
}

clap_host_mini_curve_display_t :: clap_host_mini_curve_display

CLAP_EXT_MINI_CURVE_DISPLAY: cstring : "clap.mini-curve-display/3"
