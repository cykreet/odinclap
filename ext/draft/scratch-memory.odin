package draft

imports "../.."


clap_host_scratch_memory :: struct {
	// Asks the host to reserve scratch memory.
	//
	// The plugin may call this method multiple times (for
	// example, gradually decreasing the amount of scratch
	// being asked for until the host returns true), however,
	// the plugin should avoid calling this method un-neccesarily
	// since the host implementation may be relatively expensive.
	// If the plugin calls `reserve()` multiple times, then the
	// last call invalidates all previous calls.
	//
	// De-activating the plugin releases the scratch memory.
	//
	// `max_concurrency_hint` is an optional hint which indicates
	// the maximum number of threads concurrently accessing the scratch memory.
	// Set to 0 if unspecified.
	//
	// Returns true on success.
	//
	// [main-thread & being-activated]
	reserve: proc "c" (host: ^clap_host_t, scratch_size_bytes: u32, max_concurrency_hint: u32) -> bool,

	// Returns a pointer to the "thread-local" scratch memory.
	//
	// If the scratch memory wasn't successfully reserved, returns NULL.
	//
	// If the plugin crosses `max_concurrency_hint`, then the return value
	// is either NULL or a valid scratch memory pointer.
	//
	// This method may only be called by the plugin from the audio thread,
	// (i.e. during the process() or thread_pool.exec() callback), and
	// the provided memory is only valid until the plugin returns from
	// that callback. The plugin must not hold any references to data
	// that lives in the scratch memory after returning from the callback,
	// as that data will likely be over-written by another plugin using
	// the same scratch memory.
	//
	// The provided memory is not initialized, and may have been used
	// by other plugin instances, so the plugin must correctly initialize
	// the memory when using it.
	//
	// The provided memory is owned by the host, so the plugin must not
	// free the memory.
	//
	// If the plugin wants to share the same scratch memory pointer with
	// many threads, it must access the the scratch at the beginning of the
	// `process()` callback, cache the returned pointer before calling
	// `clap_host_thread_pool->request_exec()` and clear the cached pointer
	// before returning from `process()`.
	//
	// [audio-thread]
	access: proc "c" (host: ^clap_host_t) -> rawptr,
}

clap_host_scratch_memory_t :: clap_host_scratch_memory

CLAP_EXT_SCRATCH_MEMORY: cstring : "clap.scratch-memory/1"
