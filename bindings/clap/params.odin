package clap

CLAP_PARAM_IS_STEPPED                 :: 1
CLAP_PARAM_IS_PERIODIC                :: 2
CLAP_PARAM_IS_HIDDEN                  :: 4
CLAP_PARAM_IS_READONLY                :: 8
CLAP_PARAM_IS_BYPASS                  :: 16
CLAP_PARAM_IS_AUTOMATABLE             :: 32
CLAP_PARAM_IS_AUTOMATABLE_PER_NOTE_ID :: 64
CLAP_PARAM_IS_AUTOMATABLE_PER_KEY     :: 128
CLAP_PARAM_IS_AUTOMATABLE_PER_CHANNEL :: 256
CLAP_PARAM_IS_AUTOMATABLE_PER_PORT    :: 512
CLAP_PARAM_IS_MODULATABLE             :: 1024
CLAP_PARAM_IS_MODULATABLE_PER_NOTE_ID :: 2048
CLAP_PARAM_IS_MODULATABLE_PER_KEY     :: 4096
CLAP_PARAM_IS_MODULATABLE_PER_CHANNEL :: 8192
CLAP_PARAM_IS_MODULATABLE_PER_PORT    :: 16384
CLAP_PARAM_REQUIRES_PROCESS           :: 32768
CLAP_PARAM_IS_ENUM                    :: 65536

clap_param_info_flags :: u32

/* This describes a parameter */
clap_param_info :: struct {
	// Stable parameter identifier, it must never change.
	id:    clap_id,
	flags: clap_param_info_flags,

	// This value is optional and set by the plugin.
	// Its purpose is to provide fast access to the plugin parameter object by caching its pointer.
	// For instance:
	//
	// in clap_plugin_params.get_info():
	//    Parameter *p = findParameter(param_id);
	//    param_info->cookie = p;
	//
	// later, in clap_plugin.process():
	//
	//    Parameter *p = (Parameter *)event->cookie;
	//    if (!p) [[unlikely]]
	//       p = findParameter(event->param_id);
	//
	// where findParameter() is a function the plugin implements to map parameter ids to internal
	// objects.
	//
	// Important:
	//  - The cookie is invalidated by a call to clap_host_params->rescan(CLAP_PARAM_RESCAN_ALL) or
	//    when the plugin is destroyed.
	//  - The host will either provide the cookie as issued or nullptr in events addressing
	//    parameters.
	//  - The plugin must gracefully handle the case of a cookie which is nullptr.
	//  - Many plugins will process the parameter events more quickly if the host can provide the
	//    cookie in a faster time than a hashmap lookup per param per event.
	cookie: rawptr,

	// The display name. eg: "Volume". This does not need to be unique. Do not include the module
	// text in this. The host should concatenate/format the module + name in the case where showing
	// the name alone would be too vague.
	name: [256]i8,

	// The module path containing the param, eg: "Oscillators/Wavetable 1".
	// '/' will be used as a separator to show a tree-like structure.
	module:        [1024]i8,
	min_value:     f64, // Minimum plain value. Must be finite (`std::isfinite` true)
	max_value:     f64, // Maximum plain value. Must be finite
	default_value: f64, // Default plain value. Must be in [min, max] range.
}

/* This describes a parameter */
clap_param_info_t :: clap_param_info

clap_plugin_params :: struct {
	// Returns the number of parameters.
	// [main-thread]
	count: proc "c" (plugin: ^clap_plugin_t) -> u32,

	// Copies the parameter's info to param_info.
	// Returns true on success.
	// [main-thread]
	get_info: proc "c" (plugin: ^clap_plugin_t, param_index: u32, param_info: ^clap_param_info_t) -> bool,

	// Writes the parameter's current value to out_value.
	// Returns true on success.
	// [main-thread]
	get_value: proc "c" (plugin: ^clap_plugin_t, param_id: clap_id, out_value: ^f64) -> bool,

	// Fills out_buffer with a null-terminated UTF-8 string that represents the parameter at the
	// given 'value' argument. eg: "2.3 kHz". The host should always use this to format parameter
	// values before displaying it to the user.
	// Returns true on success.
	// [main-thread]
	value_to_text: proc "c" (plugin: ^clap_plugin_t, param_id: clap_id, value: f64, out_buffer: cstring, out_buffer_capacity: u32) -> bool,

	// Converts the null-terminated UTF-8 param_value_text into a double and writes it to out_value.
	// The host can use this to convert user input into a parameter value.
	// Returns true on success.
	// [main-thread]
	text_to_value: proc "c" (plugin: ^clap_plugin_t, param_id: clap_id, param_value_text: cstring, out_value: ^f64) -> bool,

	// Flushes a set of parameter changes.
	// This method must not be called concurrently to clap_plugin->process().
	//
	// Note: if the plugin is processing, then the process() call will already achieve the
	// parameter update (bi-directional), so a call to flush isn't required, also be aware
	// that the plugin may use the sample offset in process(), while this information would be
	// lost within flush().
	//
	// [active ? audio-thread : main-thread]
	flush: proc "c" (plugin: ^clap_plugin_t, _in: ^clap_input_events_t, out: ^clap_output_events_t),
}

clap_plugin_params_t :: clap_plugin_params

CLAP_PARAM_RESCAN_VALUES :: 1
CLAP_PARAM_RESCAN_TEXT   :: 2
CLAP_PARAM_RESCAN_INFO   :: 4
CLAP_PARAM_RESCAN_ALL    :: 8

clap_param_rescan_flags :: u32

CLAP_PARAM_CLEAR_ALL         :: 1
CLAP_PARAM_CLEAR_AUTOMATIONS :: 2
CLAP_PARAM_CLEAR_MODULATIONS :: 4

clap_param_clear_flags :: u32

clap_host_params :: struct {
	// Rescan the full list of parameters according to the flags.
	// [main-thread]
	rescan: proc "c" (host: ^clap_host_t, flags: clap_param_rescan_flags),

	// Clears references to a parameter.
	// [main-thread]
	clear: proc "c" (host: ^clap_host_t, param_id: clap_id, flags: clap_param_clear_flags),

	// Request a parameter flush.
	//
	// The host will then schedule a call to either:
	// - clap_plugin.process()
	// - clap_plugin_params.flush()
	//
	// This function is always safe to use and should not be called from an [audio-thread] as the
	// plugin would already be within process() or flush().
	//
	// [thread-safe,!audio-thread]
	request_flush: proc "c" (host: ^clap_host_t),
}

clap_host_params_t :: clap_host_params

