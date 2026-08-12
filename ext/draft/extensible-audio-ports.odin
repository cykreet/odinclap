package draft

imports "../.."


clap_plugin_extensible_audio_ports :: struct {
	// Asks the plugin to add a new port (at the end of the list), with the following settings.
	// port_type: see clap_audio_port_info.port_type for interpretation.
	// port_details: see clap_audio_port_configuration_request.port_details for interpretation.
	// Returns true on success.
	// [main-thread & !active]
	add_port: proc "c" (plugin: ^clap_plugin_t, is_input: bool, channel_count: u32, port_type: cstring, port_details: rawptr) -> bool,

	// Asks the plugin to remove a port.
	// Returns true on success.
	// [main-thread & !active]
	remove_port: proc "c" (plugin: ^clap_plugin_t, is_input: bool, index: u32) -> bool,
}

clap_plugin_extensible_audio_ports_t :: clap_plugin_extensible_audio_ports

CLAP_EXT_EXTENSIBLE_AUDIO_PORTS: cstring : "clap.extensible-audio-ports/1"
