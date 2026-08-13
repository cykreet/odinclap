package ext

import ".."


CLAP_LOG_DEBUG              :: 0
CLAP_LOG_INFO               :: 1
CLAP_LOG_WARNING            :: 2
CLAP_LOG_ERROR              :: 3
CLAP_LOG_FATAL              :: 4
CLAP_LOG_HOST_MISBEHAVING   :: 5
CLAP_LOG_PLUGIN_MISBEHAVING :: 6

clap_log_severity :: i32

clap_host_log :: struct {
	// Log a message through the host.
	// [thread-safe]
	log: proc "c" (host: ^clap_host_t, severity: clap_log_severity, msg: cstring),
}

clap_host_log_t :: clap_host_log

CLAP_EXT_LOG: cstring : "clap.log"
