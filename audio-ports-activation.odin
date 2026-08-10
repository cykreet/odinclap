package clap

clap_plugin_audio_ports_activation :: struct {
	// Returns true if the plugin supports activation/deactivation while processing.
	// [main-thread]
	can_activate_while_processing: proc "c" (plugin: ^clap_plugin_t) -> bool,

	// Activate the given port.
	//
	// It is only possible to activate and de-activate on the audio-thread if
	// can_activate_while_processing() returns true.
	//
	// sample_size indicate if the host will provide 32 bit audio buffers or 64 bits one.
	// Possible values are: 32, 64 or 0 if unspecified.
	//
	// returns false if failed, or invalid parameters
	// [active ? audio-thread : main-thread]
	set_active: proc "c" (plugin: ^clap_plugin_t, is_input: bool, port_index: u32, is_active: bool, sample_size: u32) -> bool,
}

clap_plugin_audio_ports_activation_t :: clap_plugin_audio_ports_activation

