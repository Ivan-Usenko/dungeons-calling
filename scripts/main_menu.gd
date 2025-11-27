extends Control

const SETTINGS_SCENE = preload("res://scenes/settings.tscn")

@onready var name_game: Label = $Name
@onready var main_button: VBoxContainer = $MainButton

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_settings_pressed() -> void:
	name_game.visible = false
	main_button.visible = false
	
	var settings_instance = SETTINGS_SCENE.instantiate()
	add_child(settings_instance)
	settings_instance.tree_exited.connect(_on_back_pressed)

func _on_back_pressed():
	name_game.visible = true
	main_button.visible = true
	
func _on_exit_game_pressed() -> void:
	get_tree().quit()
