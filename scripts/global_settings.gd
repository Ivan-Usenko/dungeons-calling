extends Node

const SAVE_PATH = "user://game_settings.cfg"

var settings_data = {
	"resolution_index": 0,
	"display_index": 1,
	"master_vol": 1.0, 
	"ambience_vol": 1.0, 
	"sfx_vol": 1.0        
}

const RESOLUTIONS = [
	Vector2i(1920, 1080),
	Vector2i(1366, 768),
	Vector2i(1280, 720),
	Vector2i(1680, 1050),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160)
]

func _ready():
	load_data()

func apply_settings():
	var res_index = settings_data["resolution_index"]
	var disp_index = settings_data["display_index"]
	
	var size = RESOLUTIONS[res_index]
	DisplayServer.window_set_size(size)
	get_window().content_scale_size = size
	
	match disp_index:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		1: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	
	if disp_index != 0:
		center_window()

	update_bus_volume("Master", settings_data["master_vol"])
	update_bus_volume("Ambience", settings_data["ambience_vol"])
	update_bus_volume("SFX", settings_data["sfx_vol"])

func update_bus_volume(bus_name: String, vol_value: float):
	var bus_index = AudioServer.get_bus_index(bus_name)

	if bus_index == -1:
		print("ERROR: Audio bus '", bus_name, "' not found!")
		return

	if vol_value <= 0.0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(vol_value))

func save_data():
	var config = ConfigFile.new()
	config.set_value("Settings", "data", settings_data)
	config.save(SAVE_PATH)

func load_data():
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		var saved_data = config.get_value("Settings", "data", {})
		settings_data.merge(saved_data, true)
	apply_settings()

func center_window():
	await get_tree().create_timer(0.1).timeout
	var screen_center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = DisplayServer.window_get_size()
	DisplayServer.window_set_position(screen_center - window_size / 2)
