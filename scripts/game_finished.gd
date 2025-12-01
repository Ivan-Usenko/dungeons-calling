extends CanvasLayer

func _on_replay_pressed() -> void:
	GameManager.start_new_game()

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
