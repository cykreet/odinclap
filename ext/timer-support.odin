package ext

import ".."


clap_plugin_timer_support :: struct {
	// [main-thread]
	on_timer: proc "c" (plugin: ^clap_plugin_t, timer_id: clap_id),
}

clap_plugin_timer_support_t :: clap_plugin_timer_support

clap_host_timer_support :: struct {
	// Registers a periodic timer.
	// The host may adjust the period if it is under a certain threshold.
	// 30 Hz should be allowed.
	// Returns true on success.
	// [main-thread]
	register_timer: proc "c" (host: ^clap_host_t, period_ms: u32, timer_id: ^clap_id) -> bool,

	// Returns true on success.
	// [main-thread]
	unregister_timer: proc "c" (host: ^clap_host_t, timer_id: clap_id) -> bool,
}

clap_host_timer_support_t :: clap_host_timer_support

CLAP_EXT_TIMER_SUPPORT: cstring : "clap.timer-support"
