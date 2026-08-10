package clap

CLAP_POSIX_FD_READ  :: 1
CLAP_POSIX_FD_WRITE :: 2
CLAP_POSIX_FD_ERROR :: 4

clap_posix_fd_flags_t :: u32

clap_plugin_posix_fd_support :: struct {
	// This callback is "level-triggered".
	// It means that a writable fd will continuously produce "on_fd()" events;
	// don't forget using modify_fd() to remove the write notification once you're
	// done writing.
	//
	// [main-thread]
	on_fd: proc "c" (plugin: ^clap_plugin_t, fd: i32, flags: clap_posix_fd_flags_t),
}

clap_plugin_posix_fd_support_t :: clap_plugin_posix_fd_support

clap_host_posix_fd_support :: struct {
	// Returns true on success.
	// [main-thread]
	register_fd: proc "c" (host: ^clap_host_t, fd: i32, flags: clap_posix_fd_flags_t) -> bool,

	// Returns true on success.
	// [main-thread]
	modify_fd: proc "c" (host: ^clap_host_t, fd: i32, flags: clap_posix_fd_flags_t) -> bool,

	// Returns true on success.
	// [main-thread]
	unregister_fd: proc "c" (host: ^clap_host_t, fd: i32) -> bool,
}

clap_host_posix_fd_support_t :: clap_host_posix_fd_support

