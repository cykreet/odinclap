package clap

clap_note_name :: struct {
	name:    [256]i8,
	port:    i16, // -1 for every port
	key:     i16, // -1 for every key
	channel: i16, // -1 for every channel
}

clap_note_name_t :: clap_note_name

clap_plugin_note_name :: struct {
	// Return the number of note names
	// [main-thread]
	count: proc "c" (plugin: ^clap_plugin_t) -> u32,

	// Returns true on success and stores the result into note_name
	// [main-thread]
	get: proc "c" (plugin: ^clap_plugin_t, index: u32, note_name: ^clap_note_name_t) -> bool,
}

clap_plugin_note_name_t :: clap_plugin_note_name

clap_host_note_name :: struct {
	// Informs the host that the note names have changed.
	// [main-thread]
	changed: proc "c" (host: ^clap_host_t),
}

clap_host_note_name_t :: clap_host_note_name

