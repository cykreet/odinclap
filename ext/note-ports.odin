package ext

import ".."


clap_note_dialect :: enum u32 {
	// Uses clap_event_note and clap_event_note_expression.
	CLAP     = 1,

	// Uses clap_event_midi, no polyphonic expression
	MIDI     = 2,

	// Uses clap_event_midi, with polyphonic expression (MPE)
	MIDI_MPE = 4,

	// Uses clap_event_midi2
	MIDI2    = 8,
}

clap_note_port_info :: struct {
	// id identifies a port and must be stable.
	// id may overlap between input and output ports.
	id:                 clap_id,
	supported_dialects: u32,     // bitfield, see clap_note_dialect
	preferred_dialect:  u32,     // one value of clap_note_dialect
	name:               [256]i8, // displayable name, i18n?
}

clap_note_port_info_t :: clap_note_port_info

// The note ports scan has to be done while the plugin is deactivated.
clap_plugin_note_ports :: struct {
	// Number of ports, for either input or output.
	// [main-thread]
	count: proc "c" (plugin: ^clap_plugin_t, is_input: bool) -> u32,

	// Get info about a note port.
	// Returns true on success and stores the result into info.
	// [main-thread]
	get: proc "c" (plugin: ^clap_plugin_t, index: u32, is_input: bool, info: ^clap_note_port_info_t) -> bool,
}

// The note ports scan has to be done while the plugin is deactivated.
clap_plugin_note_ports_t :: clap_plugin_note_ports

CLAP_NOTE_PORTS_RESCAN_ALL   :: 1
CLAP_NOTE_PORTS_RESCAN_NAMES :: 2

clap_host_note_ports :: struct {
	// Query which dialects the host supports
	// [main-thread]
	supported_dialects: proc "c" (host: ^clap_host_t) -> u32,

	// Rescan the full list of note ports according to the flags.
	// [main-thread]
	rescan: proc "c" (host: ^clap_host_t, flags: u32),
}

clap_host_note_ports_t :: clap_host_note_ports

CLAP_EXT_NOTE_PORTS: cstring : "clap.note-ports"
