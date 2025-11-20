extends Node

func restart_on_death() -> void:
	TransitionScreen.transition()
	await TransitionScreen.transition_finised
	FootstepSoundManager.tilemaps.clear()
	get_tree().reload_current_scene()

func load_next_level() -> void:
	restart_on_death()
