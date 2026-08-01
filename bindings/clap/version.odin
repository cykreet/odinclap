package bindings

clap_version :: struct {
	// This is the major ABI and API design
	// Version 0.X.Y correspond to the development stage, API and ABI are not stable
	// Version 1.X.Y correspond to the release stage, API and ABI are stable
	major:    u32,
	minor:    u32,
	revision: u32,
}

clap_version_t :: clap_version

CLAP_VERSION_MAJOR    :: 1
CLAP_VERSION_MINOR    :: 2
CLAP_VERSION_REVISION :: 10

