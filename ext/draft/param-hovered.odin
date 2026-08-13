package draft

imports "../.."


clap_host_param_hovered :: struct {
	// Plugin informs the host about a new hover state.
	//
	// Should be called whenever the hovered UI control's parameter ID changes or when it changes
	// from hovered to not being hovered.
	//
	// Only one parameter can be hovered at a time. Use CLAP_INVALID_ID as param_id if no parameter
	// is hovered.
	//
	// [main-thread]
	update: proc "c" (host: ^clap_host_t, hovered_param_id: clap_id),
}

clap_host_param_hovered_t :: clap_host_param_hovered

CLAP_EXT_PARAM_HOVERED: cstring : "clap.param-hovered/1"
