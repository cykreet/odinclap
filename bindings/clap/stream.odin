package bindings

clap_istream :: struct {
	ctx: rawptr, // reserved pointer for the stream

	// returns the number of bytes read; 0 indicates end of file and -1 a read error
	read: proc "c" (stream: ^clap_istream, buffer: rawptr, size: u64) -> i64,
}

clap_istream_t :: clap_istream

clap_ostream :: struct {
	ctx: rawptr, // reserved pointer for the stream

	// returns the number of bytes written; -1 on write error
	write: proc "c" (stream: ^clap_ostream, buffer: rawptr, size: u64) -> i64,
}

clap_ostream_t :: clap_ostream

