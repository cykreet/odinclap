package test

import "base:runtime"
import "../bindings/clap"
import "core:c"

PluginState :: struct {
	plugin: clap.clap_plugin,
}

PLUGIN_ID		:: "com.cykreet.test"
PLUGIN_NAME		:: "Bindgen Test"
PLUGIN_VENDOR	:: "cykreet"
PLUGIN_VERSION	:: "0.0.1"

descriptor := clap.clap_plugin_descriptor {
	clap_version	= clap.CLAP_VERSION,
	id				= PLUGIN_ID,
	name			= PLUGIN_NAME,
	vendor			= PLUGIN_VENDOR,
	url				= "",
	manual_url		= "",
	support_url		= "",
	version			= PLUGIN_VERSION,
	description		= "plugin used to validate generated bindings",
	features		= raw_data([]cstring { 
		clap.CLAP_PLUGIN_FEATURE_AUDIO_EFFECT,
		clap.CLAP_PLUGIN_FEATURE_STEREO,
		nil 
	}),
}

plugin_init :: proc "c" (p: ^clap.clap_plugin) -> c.bool {
	context = runtime.default_context()
	return true	
}

plugin_destroy :: proc "c" (p: ^clap.clap_plugin) {
	state := (^PluginState)(p.plugin_data)
	free(state)
}

plugin_activate :: proc "c" (p: ^clap.clap_plugin, sample_rate: c.double, min_frames: u32, max_frames: u32) -> c.bool {
	return true	
}

plugin_deactivate :: proc "c" (p: ^clap.clap_plugin) {}

plugin_start_processing :: proc "c" (p: ^clap.clap_plugin) -> c.bool {
	return true
}

plugin_stop_processing :: proc "c" (p: ^clap.clap_plugin) {}

plugin_reset :: proc "c" (p: ^clap.clap_plugin) {}

plugin_process :: proc "c" (p: ^clap.clap_plugin, process: ^clap.clap_process) -> clap.clap_process_status {
	outputs := cast([^]clap.clap_audio_buffer_t) process.audio_outputs
	for i in 0 ..< process.audio_outputs_count {
		out := outputs[i]
		if out.data32 != nil {
			channels := cast([^]^f32) out.data32

			for ch in 0 ..< out.channel_count {
				samples := cast([^]f32) channels[ch]
				for f in 0 ..< process.frames_count do samples[f] = 0
			}
		}
	}

	return clap.CLAP_PROCESS_CONTINUE
}

plugin_get_extension :: proc "c" (p: ^clap.clap_plugin, id: cstring) -> rawptr {
	return nil
}

plugin_on_main_thread :: proc "c" (p: ^clap.clap_plugin) {}

factory_get_plugin_count :: proc "c" (factory: ^clap.clap_plugin_factory) -> u32 {
	return 1
}

factory_get_plugin_descriptor :: proc "c" (factory: ^clap.clap_plugin_factory, index: u32) -> ^clap.clap_plugin_descriptor {
	return index == 0 ? &descriptor : nil
}

factory_create_plugin :: proc "c" (factory: ^clap.clap_plugin_factory, host: ^clap.clap_host, plugin_id: cstring) -> ^clap.clap_plugin {
	if plugin_id != PLUGIN_ID {
		return nil
	}

	state := new(PluginState)
	state.plugin = clap.clap_plugin {
		desc				= &descriptor,
		plugin_data			= state,
		init				= plugin_init,
		destroy				= plugin_destroy,
		activate			= plugin_activate,
		deactivate			= plugin_deactivate,
		start_processing	= plugin_start_processing,
		stop_processing		= plugin_stop_processing,
		reset				= plugin_reset,
		process				= plugin_process,
		get_extension		= plugin_get_extension,
		on_main_thread		= plugin_on_main_thread,
	}

	return &state.plugin
}

plugin_factory := clap.clap_plugin_factory {
	get_plugin_count		= factory_get_plugin_count,
	get_plugin_descriptor	= factory_get_plugin_descriptor,
	create_plugin			= factory_create_plugin,
}

entry_init :: proc "c" (plugin_path: cstring) -> c.bool {
	return true
}

entry_deinit :: proc "c" () {}

entry_get_factory :: proc "c" (factory_id: cstring) -> rawptr {
	if factory_id == clap.CLAP_PLUGIN_FACTORY_ID {
		return &plugin_factory	
	}

	return nil
}

@(export)
clap_entry := clap.clap_plugin_entry {
	clap_version	= clap.CLAP_VERSION,
	init			= entry_init,
	deinit			= entry_deinit,
	get_factory		= entry_get_factory,
}
