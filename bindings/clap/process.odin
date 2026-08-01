package bindings

CLAP_PROCESS_ERROR                 :: 0
CLAP_PROCESS_CONTINUE              :: 1
CLAP_PROCESS_CONTINUE_IF_NOT_QUIET :: 2
CLAP_PROCESS_TAIL                  :: 3
CLAP_PROCESS_SLEEP                 :: 4

clap_process_status :: i32

clap_process :: struct {
	// A steady sample time counter.
	// This field can be used to calculate the sleep duration between two process calls.
	// This value may be specific to this plugin instance and have no relation to what
	// other plugin instances may receive.
	//
	// Set to -1 if not available, otherwise the value must be greater or equal to 0,
	// and must be increased by at least `frames_count` for the next call to process.
	steady_time: i64,

	// Number of frames to process
	frames_count: u32,

	// time info at sample 0
	// If null, then this is a free running host, no transport events will be provided
	transport: ^clap_event_transport_t,

	// Audio buffers, they must have the same count as specified
	// by clap_plugin_audio_ports->count().
	// The index maps to clap_plugin_audio_ports->get().
	// Input buffer and its contents are read-only.
	audio_inputs:        ^clap_audio_buffer_t,
	audio_outputs:       ^clap_audio_buffer_t,
	audio_inputs_count:  u32,
	audio_outputs_count: u32,

	// The input event list can't be modified.
	// Input read-only event list. The host will deliver these sorted in sample order.
	in_events: ^clap_input_events_t,

	// Output event list. The plugin must insert events in sample sorted order when inserting events
	out_events: ^clap_output_events_t,
}

clap_process_t :: clap_process

