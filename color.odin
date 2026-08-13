package clap

clap_color :: struct {
	alpha: u8,
	red:   u8,
	green: u8,
	blue:  u8,
}

clap_color_t :: clap_color

CLAP_COLOR_TRANSPARENT :: clap_color_t({0, 0, 0, 0})
