package clap

// event header
// All clap events start with an event header to determine the overall
// size of the event and its type and space (a namespacing for types).
// clap_event objects are contiguous regions of memory which can be copied
// with a memcpy of `size` bytes starting at the top of the header. As
// such, be very careful when designing clap events with internal pointers
// and other non-value-types to consider the lifetime of those members.
clap_event_header :: struct {
	size:     u32, // event size including this header, eg: sizeof (clap_event_note)
	time:     u32, // sample offset within the buffer for this event
	space_id: u16, // event space, see clap_host_event_registry
	type:     u16, // event type
	flags:    u32, // see clap_event_flags
}

// event header
// All clap events start with an event header to determine the overall
// size of the event and its type and space (a namespacing for types).
// clap_event objects are contiguous regions of memory which can be copied
// with a memcpy of `size` bytes starting at the top of the header. As
// such, be very careful when designing clap events with internal pointers
// and other non-value-types to consider the lifetime of those members.
clap_event_header_t :: clap_event_header

clap_event_flags :: enum u32 {
	// Indicate a live user event, for example a user turning a physical knob
	// or playing a physical key.
	IS_LIVE     = 1,

	// Indicate that the event should not be recorded.
	// For example this is useful when a parameter changes because of a MIDI CC,
	// because if the host records both the MIDI CC automation and the parameter
	// automation there will be a conflict.
	DONT_RECORD = 2,
}

CLAP_EVENT_NOTE_ON             :: 0
CLAP_EVENT_NOTE_OFF            :: 1
CLAP_EVENT_NOTE_CHOKE          :: 2
CLAP_EVENT_NOTE_END            :: 3
CLAP_EVENT_NOTE_EXPRESSION     :: 4
CLAP_EVENT_PARAM_VALUE         :: 5
CLAP_EVENT_PARAM_MOD           :: 6
CLAP_EVENT_PARAM_GESTURE_BEGIN :: 7
CLAP_EVENT_PARAM_GESTURE_END   :: 8
CLAP_EVENT_TRANSPORT           :: 9
CLAP_EVENT_MIDI                :: 10
CLAP_EVENT_MIDI_SYSEX          :: 11
CLAP_EVENT_MIDI2               :: 12

// Note on, off, end and choke events.
//
// Clap addresses notes and voices using the 4-value tuple
// (port, channel, key, note_id). Note on/off/end/choke
// events and parameter modulation messages are delivered with
// these values populated.
//
// Values in a note and voice address are either >= 0 if they
// are specified, or -1 to indicate a wildcard. A wildcard
// means a voice with any value in that part of the tuple
// matches the message.
//
// For instance, a (PCKN) of (0, 3, -1, -1) will match all voices
// on channel 3 of port 0. And a PCKN of (-1, 0, 60, -1) will match
// all channel 0 key 60 voices, independent of port or note id.
//
// Especially in the case of note-on note-off pairs, and in the
// absence of voice stacking or polyphonic modulation, a host may
// choose to issue a note id only at note on. So you may see a
// message stream like
//
// CLAP_EVENT_NOTE_ON  [0,0,60,184]
// CLAP_EVENT_NOTE_OFF [0,0,60,-1]
//
// and the host will expect the first voice to be released.
// Well constructed plugins will search for voices and notes using
// the entire tuple.
//
// In the case of note on events:
// - The port, channel and key must be specified with a value >= 0
// - A note-on event with a '-1' for port, channel or key is invalid and
//   can be rejected or ignored by a plugin or host.
// - A host which does not support note ids should set the note id to -1.
//
// In the case of note choke or end events:
// - the velocity is ignored.
// - key and channel are used to match active notes
// - note_id is optionally provided by the host
clap_event_note :: struct {
	header:     clap_event_header_t,
	note_id:    i32, // host provided note id >= 0, or -1 if unspecified or wildcard
	port_index: i16, // port index from ext/note-ports; -1 for wildcard
	channel:    i16, // 0..15, same as MIDI1 Channel Number, -1 for wildcard
	key:        i16, // 0..127, same as MIDI1 Key Number (60==Middle C), -1 for wildcard
	velocity:   f64, // 0..1
}

// Note on, off, end and choke events.
//
// Clap addresses notes and voices using the 4-value tuple
// (port, channel, key, note_id). Note on/off/end/choke
// events and parameter modulation messages are delivered with
// these values populated.
//
// Values in a note and voice address are either >= 0 if they
// are specified, or -1 to indicate a wildcard. A wildcard
// means a voice with any value in that part of the tuple
// matches the message.
//
// For instance, a (PCKN) of (0, 3, -1, -1) will match all voices
// on channel 3 of port 0. And a PCKN of (-1, 0, 60, -1) will match
// all channel 0 key 60 voices, independent of port or note id.
//
// Especially in the case of note-on note-off pairs, and in the
// absence of voice stacking or polyphonic modulation, a host may
// choose to issue a note id only at note on. So you may see a
// message stream like
//
// CLAP_EVENT_NOTE_ON  [0,0,60,184]
// CLAP_EVENT_NOTE_OFF [0,0,60,-1]
//
// and the host will expect the first voice to be released.
// Well constructed plugins will search for voices and notes using
// the entire tuple.
//
// In the case of note on events:
// - The port, channel and key must be specified with a value >= 0
// - A note-on event with a '-1' for port, channel or key is invalid and
//   can be rejected or ignored by a plugin or host.
// - A host which does not support note ids should set the note id to -1.
//
// In the case of note choke or end events:
// - the velocity is ignored.
// - key and channel are used to match active notes
// - note_id is optionally provided by the host
clap_event_note_t :: clap_event_note

CLAP_NOTE_EXPRESSION_VOLUME     :: 0
CLAP_NOTE_EXPRESSION_PAN        :: 1
CLAP_NOTE_EXPRESSION_TUNING     :: 2
CLAP_NOTE_EXPRESSION_VIBRATO    :: 3
CLAP_NOTE_EXPRESSION_EXPRESSION :: 4
CLAP_NOTE_EXPRESSION_BRIGHTNESS :: 5
CLAP_NOTE_EXPRESSION_PRESSURE   :: 6

clap_note_expression :: i32

clap_event_note_expression :: struct {
	header:        clap_event_header_t,
	expression_id: clap_note_expression,

	// target a specific note_id, port, key and channel, with
	// -1 meaning wildcard, per the wildcard discussion above
	note_id:    i32,
	port_index: i16,
	channel:    i16,
	key:        i16,
	value:      f64, // see expression for the range
}

clap_event_note_expression_t :: clap_event_note_expression

clap_event_param_value :: struct {
	header: clap_event_header_t,

	// target parameter
	param_id: clap_id, // @ref clap_param_info.id
	cookie:   rawptr,  // @ref clap_param_info.cookie

	// target a specific note_id, port, key and channel, with
	// -1 meaning wildcard, per the wildcard discussion above
	note_id:    i32,
	port_index: i16,
	channel:    i16,
	key:        i16,
	value:      f64,
}

clap_event_param_value_t :: clap_event_param_value

clap_event_param_mod :: struct {
	header: clap_event_header_t,

	// target parameter
	param_id: clap_id, // @ref clap_param_info.id
	cookie:   rawptr,  // @ref clap_param_info.cookie

	// target a specific note_id, port, key and channel, with
	// -1 meaning wildcard, per the wildcard discussion above
	note_id:    i32,
	port_index: i16,
	channel:    i16,
	key:        i16,
	amount:     f64, // modulation amount
}

clap_event_param_mod_t :: clap_event_param_mod

clap_event_param_gesture :: struct {
	header: clap_event_header_t,

	// target parameter
	param_id: clap_id, // @ref clap_param_info.id
}

clap_event_param_gesture_t :: clap_event_param_gesture

clap_transport_flags :: enum u32 {
	HAS_TEMPO            = 1,
	HAS_BEATS_TIMELINE   = 2,
	HAS_SECONDS_TIMELINE = 4,
	HAS_TIME_SIGNATURE   = 8,
	IS_PLAYING           = 16,
	IS_RECORDING         = 32,
	IS_LOOP_ACTIVE       = 64,
	IS_WITHIN_PRE_ROLL   = 128,
}

// clap_event_transport provides song position, tempo, and similar information
// from the host to the plugin. There are two ways a host communicates these values.
// In the `clap_process` structure sent to each processing block, the host may
// provide a transport structure which indicates the available information at the
// start of the block. If the host provides sample-accurate tempo or transport changes,
// it can also provide subsequent inter-block transport updates by delivering a new event.
clap_event_transport :: struct {
	header:           clap_event_header_t,
	flags:            u32,           // see clap_transport_flags
	song_pos_beats:   clap_beattime, // position in beats
	song_pos_seconds: clap_sectime,  // position in seconds
	tempo:            f64,           // in bpm
	tempo_inc:        f64,           // tempo increment for each sample and until the next

	// time info event
	loop_start_beats:   clap_beattime,
	loop_end_beats:     clap_beattime,
	loop_start_seconds: clap_sectime,
	loop_end_seconds:   clap_sectime,
	bar_start:          clap_beattime, // start pos of the current bar
	bar_number:         i32,           // bar at song pos 0 has the number 0
	tsig_num:           u16,           // time signature numerator
	tsig_denom:         u16,           // time signature denominator
}

// clap_event_transport provides song position, tempo, and similar information
// from the host to the plugin. There are two ways a host communicates these values.
// In the `clap_process` structure sent to each processing block, the host may
// provide a transport structure which indicates the available information at the
// start of the block. If the host provides sample-accurate tempo or transport changes,
// it can also provide subsequent inter-block transport updates by delivering a new event.
clap_event_transport_t :: clap_event_transport

clap_event_midi :: struct {
	header:     clap_event_header_t,
	port_index: u16,
	data:       [3]u8,
}

clap_event_midi_t :: clap_event_midi

// clap_event_midi_sysex contains a pointer to a sysex contents buffer.
// The lifetime of this buffer is (from host->plugin) only the process
// call in which the event is delivered or (from plugin->host) only the
// duration of a try_push call.
//
// Since `clap_output_events.try_push` requires hosts to make a copy of
// an event, host implementers receiving sysex messages from plugins need
// to take care to both copy the event (so header, size, etc...) but
// also memcpy the contents of the sysex pointer to host-owned memory, and
// not just copy the data pointer.
//
// Similarly plugins retaining the sysex outside the lifetime of a single
// process call must copy the sysex buffer to plugin-owned memory.
//
// As a consequence, the data structure pointed to by the sysex buffer
// must be contiguous and copyable with `memcpy` of `size` bytes.
clap_event_midi_sysex :: struct {
	header:     clap_event_header_t,
	port_index: u16,
	buffer:     ^u8, // midi buffer. See lifetime comment above.
	size:       u32,
}

// clap_event_midi_sysex contains a pointer to a sysex contents buffer.
// The lifetime of this buffer is (from host->plugin) only the process
// call in which the event is delivered or (from plugin->host) only the
// duration of a try_push call.
//
// Since `clap_output_events.try_push` requires hosts to make a copy of
// an event, host implementers receiving sysex messages from plugins need
// to take care to both copy the event (so header, size, etc...) but
// also memcpy the contents of the sysex pointer to host-owned memory, and
// not just copy the data pointer.
//
// Similarly plugins retaining the sysex outside the lifetime of a single
// process call must copy the sysex buffer to plugin-owned memory.
//
// As a consequence, the data structure pointed to by the sysex buffer
// must be contiguous and copyable with `memcpy` of `size` bytes.
clap_event_midi_sysex_t :: clap_event_midi_sysex

// While it is possible to use a series of midi2 event to send a sysex,
// prefer clap_event_midi_sysex if possible for efficiency.
clap_event_midi2 :: struct {
	header:     clap_event_header_t,
	port_index: u16,
	data:       [4]u32,
}

// While it is possible to use a series of midi2 event to send a sysex,
// prefer clap_event_midi_sysex if possible for efficiency.
clap_event_midi2_t :: clap_event_midi2

// Input event list. The host will deliver these sorted in sample order.
clap_input_events :: struct {
	ctx: rawptr, // reserved pointer for the list

	// returns the number of events in the list
	size: proc "c" (list: ^clap_input_events) -> u32,

	// Don't free the returned event, it belongs to the list
	get: proc "c" (list: ^clap_input_events, index: u32) -> ^clap_event_header_t,
}

// Input event list. The host will deliver these sorted in sample order.
clap_input_events_t :: clap_input_events

// Output event list. The plugin must insert events in sample sorted order when inserting events
clap_output_events :: struct {
	ctx: rawptr, // reserved pointer for the list

	// Pushes a copy of the event
	// returns false if the event could not be pushed to the queue (out of memory?)
	try_push: proc "c" (list: ^clap_output_events, event: ^clap_event_header_t) -> bool,
}

// Output event list. The plugin must insert events in sample sorted order when inserting events
clap_output_events_t :: clap_output_events

CLAP_CORE_EVENT_SPACE_ID :: u16(0)
