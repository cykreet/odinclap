package clap

// Every method must be thread-safe.
// It is very important to be able to scan the plugin as quickly as possible.
//
// The host may use clap_plugin_invalidation_factory to detect filesystem changes
// which may change the factory's content.
clap_plugin_factory :: struct {
	// Get the number of plugins available.
	// [thread-safe]
	get_plugin_count: proc "c" (factory: ^clap_plugin_factory) -> u32,

	// Retrieves a plugin descriptor by its index.
	// The descriptor is owned by the plugin and is valid until the call to clap_plugin_entry->deinit()
	// Returns null in case of error.
	// [thread-safe]
	get_plugin_descriptor: proc "c" (factory: ^clap_plugin_factory, index: u32) -> ^clap_plugin_descriptor_t,

	// Create a clap_plugin by its plugin_id.
	// The clap_host pointer must be valid until after the call to plugin->destroy(plugin).
	// The returned pointer is owned by the plugin and must be freed by calling plugin->destroy(plugin);
	// The plugin is not allowed to use the host callbacks in the create method.
	// Returns null in case of error.
	// [thread-safe]
	create_plugin: proc "c" (factory: ^clap_plugin_factory, host: ^clap_host_t, plugin_id: cstring) -> ^clap_plugin_t,
}

// Every method must be thread-safe.
// It is very important to be able to scan the plugin as quickly as possible.
//
// The host may use clap_plugin_invalidation_factory to detect filesystem changes
// which may change the factory's content.
clap_plugin_factory_t :: clap_plugin_factory

