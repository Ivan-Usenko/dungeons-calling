extends Control

@onready var display_button: OptionButton = $VBoxContainer/DisplayButton
@onready var resolution_button: OptionButton = $VBoxContainer/ResolutionButton
@onready var master_slider: HSlider = $VBoxContainer/TotalControl
@onready var ambience_slider: HSlider = $VBoxContainer/TotalControl2
@onready var sfx_slider: HSlider = $VBoxContainer/TotalControl3

func _ready() -> void:
	resolution_button.clear()
	for res in GlobalSettings.RESOLUTIONS:
		resolution_button.add_item(str(res.x) + " x " + str(res.y))
	
	resolution_button.selected = GlobalSettings.settings_data["resolution_index"]
	display_button.selected = GlobalSettings.settings_data["display_index"]
	
	master_slider.value = GlobalSettings.settings_data["master_vol"]
	ambience_slider.value = GlobalSettings.settings_data["ambience_vol"]
	sfx_slider.value = GlobalSettings.settings_data["sfx_vol"]
	
	if not display_button.item_selected.is_connected(_on_display_mode_selected):
		display_button.item_selected.connect(_on_display_mode_selected)
	if not resolution_button.item_selected.is_connected(_on_resolution_selected):
		resolution_button.item_selected.connect(_on_resolution_selected)
	
	if not master_slider.value_changed.is_connected(_on_master_changed):
		master_slider.value_changed.connect(_on_master_changed)
	if not ambience_slider.value_changed.is_connected(_on_ambience_changed):
		ambience_slider.value_changed.connect(_on_ambience_changed)
	if not sfx_slider.value_changed.is_connected(_on_sfx_changed):
		sfx_slider.value_changed.connect(_on_sfx_changed)

func _on_back_pressed() -> void:
	GlobalSettings.save_data()
	queue_free()

func _on_display_mode_selected(index: int) -> void:
	GlobalSettings.settings_data["display_index"] = index
	GlobalSettings.apply_settings()

func _on_resolution_selected(index: int) -> void:
	GlobalSettings.settings_data["resolution_index"] = index
	GlobalSettings.apply_settings()

func _on_master_changed(value: float) -> void:
	GlobalSettings.settings_data["master_vol"] = value
	GlobalSettings.apply_settings()

func _on_ambience_changed(value: float) -> void:
	GlobalSettings.settings_data["ambience_vol"] = value
	GlobalSettings.apply_settings()

func _on_sfx_changed(value: float) -> void:
	GlobalSettings.settings_data["sfx_vol"] = value
	GlobalSettings.apply_settings()
