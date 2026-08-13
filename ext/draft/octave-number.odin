package draft

imports "../.."


clap_plugin_octave_number :: struct {
	// If displaying the name of a note, and using standard CDEFGAB scale note names
	// on a piano-roll-like display, this api will tell the plugin which octave number is
	// associated with note 60.  For instance, calling this with '3' would indicate to
	// the plugin that the consistent name for note 60 is "C3", for 72 is "C4" etc...
	// if using CDEFGAB note names across a 12 note display.
	// [main-thread]
	set_note60_octave: proc "c" (plugin: ^clap_plugin_t, octave_number: i8),
}

clap_plugin_octave_number_t :: clap_plugin_octave_number

CLAP_EXT_OCTAVE_NUMBER: cstring : "clap.octave-number/1"
