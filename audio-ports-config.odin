package clap

// Minimalistic description of ports configuration
clap_audio_ports_config :: struct {
	id:                clap_id,
	name:              [256]i8,
	input_port_count:  u32,
	output_port_count: u32,

	// main input info
	has_main_input:           bool,
	main_input_channel_count: u32,
	main_input_port_type:     cstring,

	// main output info
	has_main_output:           bool,
	main_output_channel_count: u32,
	main_output_port_type:     cstring,
}

// Minimalistic description of ports configuration
clap_audio_ports_config_t :: clap_audio_ports_config

// The audio ports config scan has to be done while the plugin is deactivated.
clap_plugin_audio_ports_config :: struct {
	// Gets the number of available configurations
	// [main-thread]
	count: proc "c" (plugin: ^clap_plugin_t) -> u32,

	// Gets information about a configuration
	// Returns true on success and stores the result into config.
	// [main-thread]
	get: proc "c" (plugin: ^clap_plugin_t, index: u32, config: ^clap_audio_ports_config_t) -> bool,

	// Selects the configuration designated by id
	// Returns true if the configuration could be applied.
	// Once applied the host should scan again the audio ports.
	// [main-thread & plugin-deactivated]
	select: proc "c" (plugin: ^clap_plugin_t, config_id: clap_id) -> bool,
}

// The audio ports config scan has to be done while the plugin is deactivated.
clap_plugin_audio_ports_config_t :: clap_plugin_audio_ports_config

// Extended config info
clap_plugin_audio_ports_config_info :: struct {
	// Gets the id of the currently selected config, or CLAP_INVALID_ID if the current port
	// layout isn't part of the config list.
	//
	// [main-thread]
	current_config: proc "c" (plugin: ^clap_plugin_t) -> clap_id,

	// Get info about an audio port, for a given config_id.
	// This is analogous to clap_plugin_audio_ports.get().
	// Returns true on success and stores the result into info.
	// [main-thread]
	get: proc "c" (plugin: ^clap_plugin_t, config_id: clap_id, port_index: u32, is_input: bool, info: ^clap_audio_port_info_t) -> bool,
}

// Extended config info
clap_plugin_audio_ports_config_info_t :: clap_plugin_audio_ports_config_info

clap_host_audio_ports_config :: struct {
	// Rescan the full list of configs.
	// [main-thread]
	rescan: proc "c" (host: ^clap_host_t),
}

clap_host_audio_ports_config_t :: clap_host_audio_ports_config

