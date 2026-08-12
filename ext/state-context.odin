package ext

import ".."


clap_plugin_state_context_type :: enum u32 {
	// suitable for storing and loading a state as a preset
	PRESET    = 1,

	// suitable for duplicating a plugin instance
	DUPLICATE = 2,

	// suitable for storing and loading a state within a project/song
	PROJECT   = 3,
}

clap_plugin_state_context :: struct {
	// Saves the plugin state into stream, according to context_type.
	// Returns true if the state was correctly saved.
	//
	// Note that the result may be loaded by both clap_plugin_state.load() and
	// clap_plugin_state_context.load().
	// [main-thread]
	save: proc "c" (plugin: ^clap_plugin_t, stream: ^clap_ostream_t, context_type: u32) -> bool,

	// Loads the plugin state from stream, according to context_type.
	// Returns true if the state was correctly restored.
	//
	// Note that the state may have been saved by clap_plugin_state.save() or
	// clap_plugin_state_context.save() with a different context_type.
	// [main-thread]
	load: proc "c" (plugin: ^clap_plugin_t, stream: ^clap_istream_t, context_type: u32) -> bool,
}

clap_plugin_state_context_t :: clap_plugin_state_context

CLAP_EXT_STATE_CONTEXT: cstring : "clap.state-context/2"
