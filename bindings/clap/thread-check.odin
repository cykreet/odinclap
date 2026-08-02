package clap

// This interface is useful to do runtime checks and make
// sure that the functions are called on the correct threads.
// It is highly recommended that hosts implement this extension.
clap_host_thread_check :: struct {
	// Returns true if "this" thread is the main thread.
	// [thread-safe]
	is_main_thread: proc "c" (host: ^clap_host_t) -> bool,

	// Returns true if "this" thread is one of the audio threads.
	// [thread-safe]
	is_audio_thread: proc "c" (host: ^clap_host_t) -> bool,
}

// This interface is useful to do runtime checks and make
// sure that the functions are called on the correct threads.
// It is highly recommended that hosts implement this extension.
clap_host_thread_check_t :: clap_host_thread_check

