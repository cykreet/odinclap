package ext

import ".."


clap_plugin_thread_pool :: struct {
	// Called by the thread pool
	exec: proc "c" (plugin: ^clap_plugin_t, task_index: u32),
}

clap_plugin_thread_pool_t :: clap_plugin_thread_pool

clap_host_thread_pool :: struct {
	// Schedule num_tasks jobs in the host thread pool.
	// It can't be called concurrently or from the thread pool.
	// Will block until all the tasks are processed.
	// This must be used exclusively for realtime processing within the process call.
	// Returns true if the host did execute all the tasks, false if it rejected the request.
	// The host should check that the plugin is within the process call, and if not, reject the exec
	// request.
	// [audio-thread]
	request_exec: proc "c" (host: ^clap_host_t, num_tasks: u32) -> bool,
}

clap_host_thread_pool_t :: clap_host_thread_pool

CLAP_EXT_THREAD_POOL: cstring : "clap.thread-pool"
