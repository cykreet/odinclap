package draft

imports "../.."


CLAP_TRIGGER_IS_AUTOMATABLE_PER_NOTE_ID :: 1
CLAP_TRIGGER_IS_AUTOMATABLE_PER_KEY     :: 2
CLAP_TRIGGER_IS_AUTOMATABLE_PER_CHANNEL :: 4
CLAP_TRIGGER_IS_AUTOMATABLE_PER_PORT    :: 8

clap_trigger_info_flags :: u32

CLAP_EVENT_TRIGGER :: 0

clap_event_trigger :: struct {
	header: clap_event_header_t,

	// target trigger
	trigger_id: clap_id, // @ref clap_trigger_info.id
	cookie:     rawptr,  // @ref clap_trigger_info.cookie

	// target a specific note_id, port, key and channel, -1 for global
	note_id:    i32,
	port_index: i16,
	channel:    i16,
	key:        i16,
}

clap_event_trigger_t :: clap_event_trigger

/* This describes a trigger */
clap_trigger_info :: struct {
	// stable trigger identifier, it must never change.
	id:    clap_id,
	flags: clap_trigger_info_flags,

	// in analogy to clap_param_info.cookie
	cookie: rawptr,

	// displayable name
	name: [256]i8,

	// the module path containing the trigger, eg:"sequencers/seq1"
	// '/' will be used as a separator to show a tree like structure.
	module: [1024]i8,
}

/* This describes a trigger */
clap_trigger_info_t :: clap_trigger_info

clap_plugin_triggers :: struct {
	// Returns the number of triggers.
	// [main-thread]
	count: proc "c" (plugin: ^clap_plugin_t) -> u32,

	// Copies the trigger's info to trigger_info and returns true on success.
	// [main-thread]
	get_info: proc "c" (plugin: ^clap_plugin_t, index: u32, trigger_info: ^clap_trigger_info_t) -> bool,
}

clap_plugin_triggers_t :: clap_plugin_triggers

CLAP_TRIGGER_RESCAN_INFO :: 1
CLAP_TRIGGER_RESCAN_ALL  :: 2

clap_trigger_rescan_flags :: u32

CLAP_TRIGGER_CLEAR_ALL         :: 1
CLAP_TRIGGER_CLEAR_AUTOMATIONS :: 2

clap_trigger_clear_flags :: u32

clap_host_triggers :: struct {
	// Rescan the full list of triggers according to the flags.
	// [main-thread]
	rescan: proc "c" (host: ^clap_host_t, flags: clap_trigger_rescan_flags),

	// Clears references to a trigger.
	// [main-thread]
	clear: proc "c" (host: ^clap_host_t, trigger_id: clap_id, flags: clap_trigger_clear_flags),
}

clap_host_triggers_t :: clap_host_triggers

CLAP_EXT_TRIGGERS: cstring : "clap.triggers/1"
