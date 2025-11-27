extends CanvasLayer

const SETTINGS_SCENE = preload("res://scenes/settings.tscn")

@onready var main_button: VBoxContainer = $MainButton

func _on_continue_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _on_settings_pressed() -> void:
	main_button.visible = false
	var settings_instance = SETTINGS_SCENE.instantiate()
	add_child(settings_instance)
	settings_instance.tree_exited.connect(_on_back_from_settings)

func _on_back_from_settings():
	main_button.visible = true

func _on_exit_menu_pressed() -> void:
	FootstepSoundManager.tilemaps.clear()
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_exit_game_pressed() -> void:
	get_tree().quit()
