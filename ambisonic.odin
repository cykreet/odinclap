package clap

clap_ambisonic_ordering :: enum u32 {
	// FuMa channel ordering
	FUMA = 0,

	// ACN channel ordering
	ACN  = 1,
}

clap_ambisonic_normalization :: enum u32 {
	MAXN = 0,
	SN3D = 1,
	N3D  = 2,
	SN2D = 3,
	N2D  = 4,
}

clap_ambisonic_config :: struct {
	ordering:      u32, // see clap_ambisonic_ordering
	normalization: u32, // see clap_ambisonic_normalization
}

clap_ambisonic_config_t :: clap_ambisonic_config

clap_plugin_ambisonic :: struct {
	// Returns true if the given configuration is supported.
	// [main-thread]
	is_config_supported: proc "c" (plugin: ^clap_plugin_t, config: ^clap_ambisonic_config_t) -> bool,

	// Returns true on success
	// [main-thread]
	get_config: proc "c" (plugin: ^clap_plugin_t, is_input: bool, port_index: u32, config: ^clap_ambisonic_config_t) -> bool,
}

clap_plugin_ambisonic_t :: clap_plugin_ambisonic

clap_host_ambisonic :: struct {
	// Informs the host that the info has changed.
	// The info can only change when the plugin is de-activated.
	// [main-thread]
	changed: proc "c" (host: ^clap_host_t),
}

clap_host_ambisonic_t :: clap_host_ambisonic

