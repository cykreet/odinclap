package clap

CLAP_REMOTE_CONTROLS_COUNT :: 8

clap_remote_controls_page :: struct {
	section_name: [256]i8,
	page_id:      clap_id,
	page_name:    [256]i8,
	param_ids:    [8]clap_id,

	// This is used to separate device pages versus preset pages.
	// If true, then this page is specific to this preset.
	is_for_preset: bool,
}

clap_remote_controls_page_t :: clap_remote_controls_page

clap_plugin_remote_controls :: struct {
	// Returns the number of pages.
	// [main-thread]
	count: proc "c" (plugin: ^clap_plugin_t) -> u32,

	// Get a page by index.
	// Returns true on success and stores the result into page.
	// [main-thread]
	get: proc "c" (plugin: ^clap_plugin_t, page_index: u32, page: ^clap_remote_controls_page_t) -> bool,
}

clap_plugin_remote_controls_t :: clap_plugin_remote_controls

clap_host_remote_controls :: struct {
	// Informs the host that the remote controls have changed.
	// [main-thread]
	changed: proc "c" (host: ^clap_host_t),

	// Suggest a page to the host because it corresponds to what the user is currently editing in the
	// plugin's GUI.
	// [main-thread]
	suggest_page: proc "c" (host: ^clap_host_t, page_id: clap_id),
}

clap_host_remote_controls_t :: clap_host_remote_controls

