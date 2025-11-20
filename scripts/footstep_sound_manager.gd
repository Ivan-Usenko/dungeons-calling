extends Node

var tilemaps: Array[TileMapLayer] = []

const footstep_sounds = {
	"stone": [
		preload("res://assets/audio/sfx/footsteps/dirt/Footstep_Dirt_00.wav"),
		preload("res://assets/audio/sfx/footsteps/dirt/Footstep_Dirt_01.wav"),
		preload("res://assets/audio/sfx/footsteps/dirt/Footstep_Dirt_02.wav"),
		preload("res://assets/audio/sfx/footsteps/dirt/Footstep_Dirt_03.wav"),
		preload("res://assets/audio/sfx/footsteps/dirt/Footstep_Dirt_04.wav"),
		preload("res://assets/audio/sfx/footsteps/dirt/Footstep_Dirt_05.wav"),
		preload("res://assets/audio/sfx/footsteps/dirt/Footstep_Dirt_06.wav"),
		preload("res://assets/audio/sfx/footsteps/dirt/Footstep_Dirt_07.wav"),
		preload("res://assets/audio/sfx/footsteps/dirt/Footstep_Dirt_08.wav"),
		preload("res://assets/audio/sfx/footsteps/dirt/Footstep_Dirt_09.wav")
	],
	"wood": [
		preload("res://assets/audio/sfx/footsteps/wood/step_wood_00.wav"),
		preload("res://assets/audio/sfx/footsteps/wood/step_wood_01.wav"),
		preload("res://assets/audio/sfx/footsteps/wood/step_wood_02.wav"),
	]
}

const landing_sounds = {
	"stone": [
		preload("res://assets/audio/sfx/landing/stone/stone_landing.wav")
	],
	"wood": [
		preload("res://assets/audio/sfx/landing/wood/1.ogg"),
		preload("res://assets/audio/sfx/landing/wood/2.ogg"),
		preload("res://assets/audio/sfx/landing/wood/3.ogg"),
		preload("res://assets/audio/sfx/landing/wood/4.ogg"),
		preload("res://assets/audio/sfx/landing/wood/5.ogg"),
		preload("res://assets/audio/sfx/landing/wood/6.ogg"),
		preload("res://assets/audio/sfx/landing/wood/7.ogg"),
		preload("res://assets/audio/sfx/landing/wood/8.ogg"),
	]
}

func _play_action(position: Vector2, collection) -> void:
	var tile_data = []
	for tilemap in tilemaps:
		var tile_position = tilemap.local_to_map(position / tilemap.global_scale)
		var data = tilemap.get_cell_tile_data(tile_position)
		if data:
			tile_data.push_back(data)
	
	if tile_data.size() > 0:
		var tile_type = tile_data.back().get_custom_data("footstep_sound")
		
		if footstep_sounds.has(tile_type):
			var audio_player = AudioStreamPlayer2D.new()
			audio_player.stream = collection[tile_type].pick_random()
			get_tree().root.add_child(audio_player)
			audio_player.global_position = position
			audio_player.play()
			await audio_player.finished
			audio_player.queue_free()

func play_footstep(position: Vector2) -> void:
	_play_action(position, footstep_sounds)

func play_landing(position: Vector2) -> void:
	_play_action(position, landing_sounds)
