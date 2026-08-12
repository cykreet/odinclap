package draft

imports "../.."


clap_host_transport_control :: struct {
	// Jumps back to the start point and starts the transport
	// [main-thread]
	request_start: proc "c" (host: ^clap_host_t),

	// Stops the transport, and jumps to the start point
	// [main-thread]
	request_stop: proc "c" (host: ^clap_host_t),

	// If not playing, starts the transport from its current position
	// [main-thread]
	request_continue: proc "c" (host: ^clap_host_t),

	// If playing, stops the transport at the current position
	// [main-thread]
	request_pause: proc "c" (host: ^clap_host_t),

	// Equivalent to what "space bar" does with most DAWs
	// [main-thread]
	request_toggle_play: proc "c" (host: ^clap_host_t),

	// Jumps the transport to the given position.
	// Does not start the transport.
	// [main-thread]
	request_jump: proc "c" (host: ^clap_host_t, position: clap_beattime),

	// Sets the loop region
	// [main-thread]
	request_loop_region: proc "c" (host: ^clap_host_t, start: clap_beattime, duration: clap_beattime),

	// Toggles looping
	// [main-thread]
	request_toggle_loop: proc "c" (host: ^clap_host_t),

	// Enables/Disables looping
	// [main-thread]
	request_enable_loop: proc "c" (host: ^clap_host_t, is_enabled: bool),

	// Enables/Disables recording
	// [main-thread]
	request_record: proc "c" (host: ^clap_host_t, is_recording: bool),

	// Toggles recording
	// [main-thread]
	request_toggle_record: proc "c" (host: ^clap_host_t),

	// Sets tempo
	// [main-thread]
	request_tempo: proc "c" (host: ^clap_host_t, tempo: f64),

	// Sets time signature, same format as in clap_event_transport_t.
	// [main-thread]
	request_time_signature: proc "c" (host: ^clap_host_t, tsig_num: u16, tsig_denom: u16),
}

clap_host_transport_control_t :: clap_host_transport_control

CLAP_EXT_TRANSPORT_CONTROL: cstring : "clap.transport-control/2"
