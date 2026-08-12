package draft

imports "../.."


clap_host_background_progress :: struct {
	// Returns true if the host wants to cancel this task.
	// [background-thread]
	is_canceled: proc "c" (host: ^clap_host_t) -> bool,

	// Reports progress to the host.
	// The progress value is from 0 to 1.
	// 0 at the begining and 1 at the end.
	//
	// Be aware that the progress may go backward if a sub-task fails and the plugin decides to retry
	// it.
	//
	// msg: an optional null terminated message (maybe nullptr) explaining what the plugin is currently
	// doing. For example: "Downloading xxx...", "Analyzing...", "Connecting to HW...", and so on.
	//
	// [background-thread]
	progress: proc "c" (host: ^clap_host_t, progress: f64, msg: cstring),
}

clap_host_background_progress_t :: clap_host_background_progress

CLAP_EXT_BACKGROUND_PROGRESS: cstring : "clap.background-progress/1"
