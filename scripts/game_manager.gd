extends Node

const levels = [
	preload("res://levels/level_0.tscn"),
	preload("res://levels/level_1.tscn")
]
var current_level_index = 0;

const GAME_SCENE = preload("res://scenes/game.tscn")
const PAUSE_SCENE = preload("res://scenes/pause.tscn")
const LEVEL_PASSED_SCENE = preload("res://scenes/level_passed.tscn")
const GAME_FINISHED_SCENE = preload("res://scenes/game_finished.tscn")
var pause_instance = null

func restart_on_death() -> void:
	TransitionScreen.transition()
	await TransitionScreen.transition_finised
	FootstepSoundManager.tilemaps.clear()
	get_tree().reload_current_scene()

func level_passed() -> void:
	FootstepSoundManager.tilemaps.clear()
	if current_level_index == levels.size() - 1:
		get_tree().call_deferred("change_scene_to_packed", GAME_FINISHED_SCENE)
	else:
		get_tree().call_deferred("change_scene_to_packed", LEVEL_PASSED_SCENE)

func start_game() -> void:
	get_tree().change_scene_to_packed(GAME_SCENE)

func load_level(index: int) -> void:
	var game_scene = get_tree().current_scene
	for child in game_scene.get_children():
		child.queue_free()
	
	print(index)
	var level = levels[index]
	game_scene.add_child(level.instantiate())
	
	current_level_index = index

func start_new_game() -> void:
	current_level_index = 0
	start_game()

func next_level() -> void:
	current_level_index = (current_level_index + 1) % levels.size()
	start_game()

func load_current_level() -> void:
	load_level(current_level_index)

func _input(event: InputEvent) -> void:
	var current_scene_name = get_tree().current_scene.name
	if event.is_action_pressed("pause") and current_scene_name == "Game":
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
