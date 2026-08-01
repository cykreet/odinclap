// this is a manually maintained list of constants for CLAP, not normally included
// in the automated binding generation from odin-c-bindgen

package clap

CLAP_VERSION_INIT		:: { CLAP_VERSION_MAJOR, CLAP_VERSION_MINOR, CLAP_VERSION_REVISION }
CLAP_VERSION			:: CLAP_VERSION_INIT 
CLAP_PLUGIN_FACTORY_ID 	:: "clap.plugin_factory"

CLAP_TIMESTAMP_UNKNOWN	:: 0

CLAP_INVALID_ID			:: max(u32)

CLAP_COLOR_TRANSPARENT	:: { 0, 0, 0, 0}
