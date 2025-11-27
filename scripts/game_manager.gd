extends Node

const PAUSE_SCENE = preload("res://scenes/pause.tscn")
var pause_instance = null

func restart_on_death() -> void:
	TransitionScreen.transition()
	await TransitionScreen.transition_finised
	FootstepSoundManager.tilemaps.clear()
	get_tree().reload_current_scene()

func load_next_level() -> void:
	restart_on_death()

func _input(event: InputEvent) -> void:
	var current_scene_name = get_tree().current_scene.name
	if event.is_action_pressed("pause") and current_scene_name != "MainMenu":
		toggle_pause()

func toggle_pause() -> void:
	if not is_instance_valid(pause_instance):
		pause_instance = PAUSE_SCENE.instantiate()
		get_tree().root.add_child(pause_instance)
		get_tree().paused = true
	else:
		pause_instance.queue_free()
		pause_instance = null
		get_tree().paused = false
