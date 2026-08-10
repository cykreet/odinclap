package clap

CLAP_PARAM_INDICATION_AUTOMATION_NONE       :: 0
CLAP_PARAM_INDICATION_AUTOMATION_PRESENT    :: 1
CLAP_PARAM_INDICATION_AUTOMATION_PLAYING    :: 2
CLAP_PARAM_INDICATION_AUTOMATION_RECORDING  :: 3
CLAP_PARAM_INDICATION_AUTOMATION_OVERRIDING :: 4

clap_plugin_param_indication :: struct {
	// Sets or clears a mapping indication.
	//
	// has_mapping: does the parameter currently has a mapping?
	// color: if set, the color to use to highlight the control in the plugin GUI
	// label: if set, a small string to display on top of the knob which identifies the hardware
	// controller description: if set, a string which can be used in a tooltip, which describes the
	// current mapping
	//
	// Parameter indications should not be saved in the plugin context, and are off by default.
	// [main-thread]
	set_mapping: proc "c" (plugin: ^clap_plugin_t, param_id: clap_id, has_mapping: bool, color: ^clap_color_t, label: cstring, description: cstring),

	// Sets or clears an automation indication.
	//
	// automation_state: current automation state for the given parameter
	// color: if set, the color to use to display the automation indication in the plugin GUI
	//
	// Parameter indications should not be saved in the plugin context, and are off by default.
	// [main-thread]
	set_automation: proc "c" (plugin: ^clap_plugin_t, param_id: clap_id, automation_state: u32, color: ^clap_color_t),
}

clap_plugin_param_indication_t :: clap_plugin_param_indication

