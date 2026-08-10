package clap

clap_host_event_registry :: struct {
	// Queries an event space id.
	// The space id 0 is reserved for CLAP's core events. See CLAP_CORE_EVENT_SPACE.
	//
	// Return false and sets *space_id to UINT16_MAX if the space name is unknown to the host.
	// [main-thread]
	query: proc "c" (host: ^clap_host_t, space_name: cstring, space_id: ^u16) -> bool,
}

clap_host_event_registry_t :: clap_host_event_registry

