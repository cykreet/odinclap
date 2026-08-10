package clap

CLAP_CONTEXT_MENU_TARGET_KIND_GLOBAL :: 0
CLAP_CONTEXT_MENU_TARGET_KIND_PARAM  :: 1

// Describes the context menu target
clap_context_menu_target :: struct {
	kind: u32,
	id:   clap_id,
}

// Describes the context menu target
clap_context_menu_target_t :: clap_context_menu_target

CLAP_CONTEXT_MENU_ITEM_ENTRY         :: 0
CLAP_CONTEXT_MENU_ITEM_CHECK_ENTRY   :: 1
CLAP_CONTEXT_MENU_ITEM_SEPARATOR     :: 2
CLAP_CONTEXT_MENU_ITEM_BEGIN_SUBMENU :: 3
CLAP_CONTEXT_MENU_ITEM_END_SUBMENU   :: 4
CLAP_CONTEXT_MENU_ITEM_TITLE         :: 5

clap_context_menu_item_kind_t :: u32

clap_context_menu_entry :: struct {
	// text to be displayed
	label: cstring,

	// if false, then the menu entry is greyed out and not clickable
	is_enabled: bool,
	action_id:  clap_id,
}

clap_context_menu_entry_t :: clap_context_menu_entry

clap_context_menu_check_entry :: struct {
	// text to be displayed
	label: cstring,

	// if false, then the menu entry is greyed out and not clickable
	is_enabled: bool,

	// if true, then the menu entry will be displayed as checked
	is_checked: bool,
	action_id:  clap_id,
}

clap_context_menu_check_entry_t :: clap_context_menu_check_entry

clap_context_menu_item_title :: struct {
	// text to be displayed
	title: cstring,

	// if false, then the menu entry is greyed out
	is_enabled: bool,
}

clap_context_menu_item_title_t :: clap_context_menu_item_title

clap_context_menu_submenu :: struct {
	// text to be displayed
	label: cstring,

	// if false, then the menu entry is greyed out and won't show submenu
	is_enabled: bool,
}

clap_context_menu_submenu_t :: clap_context_menu_submenu

// Context menu builder.
// This object isn't thread-safe and must be used on the same thread as it was provided.
clap_context_menu_builder :: struct {
	ctx: rawptr,

	// Adds an entry to the menu.
	// item_data type is determined by item_kind.
	// Returns true on success.
	add_item: proc "c" (builder: ^clap_context_menu_builder, item_kind: clap_context_menu_item_kind_t, item_data: rawptr) -> bool,

	// Returns true if the menu builder supports the given item kind
	supports: proc "c" (builder: ^clap_context_menu_builder, item_kind: clap_context_menu_item_kind_t) -> bool,
}

// Context menu builder.
// This object isn't thread-safe and must be used on the same thread as it was provided.
clap_context_menu_builder_t :: clap_context_menu_builder

clap_plugin_context_menu :: struct {
	// Insert plugin's menu items into the menu builder.
	// If target is null, assume global context.
	// Returns true on success.
	// [main-thread]
	populate: proc "c" (plugin: ^clap_plugin_t, target: ^clap_context_menu_target_t, builder: ^clap_context_menu_builder_t) -> bool,

	// Performs the given action, which was previously provided to the host via populate().
	// If target is null, assume global context.
	// Returns true on success.
	// [main-thread]
	perform: proc "c" (plugin: ^clap_plugin_t, target: ^clap_context_menu_target_t, action_id: clap_id) -> bool,
}

clap_plugin_context_menu_t :: clap_plugin_context_menu

clap_host_context_menu :: struct {
	// Insert host's menu items into the menu builder.
	// If target is null, assume global context.
	// Returns true on success.
	// [main-thread]
	populate: proc "c" (host: ^clap_host_t, target: ^clap_context_menu_target_t, builder: ^clap_context_menu_builder_t) -> bool,

	// Performs the given action, which was previously provided to the plugin via populate().
	// If target is null, assume global context.
	// Returns true on success.
	// [main-thread]
	perform: proc "c" (host: ^clap_host_t, target: ^clap_context_menu_target_t, action_id: clap_id) -> bool,

	// Returns true if the host can display a popup menu for the plugin.
	// This may depend upon the current windowing system used to display the plugin, so the
	// return value is invalidated after creating the plugin window.
	// [main-thread]
	can_popup: proc "c" (host: ^clap_host_t) -> bool,

	// Shows the host popup menu for a given parameter.
	// If the plugin is using embedded GUI, then x and y are relative to the plugin's window,
	// otherwise they're absolute coordinate, and screen index might be set accordingly.
	// If target is null, assume global context.
	// Returns true on success.
	// [main-thread]
	popup: proc "c" (host: ^clap_host_t, target: ^clap_context_menu_target_t, screen_index: i32, x: i32, y: i32) -> bool,
}

clap_host_context_menu_t :: clap_host_context_menu

