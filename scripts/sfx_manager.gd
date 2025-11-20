extends Node

const sfx = {
	"swing": [
		preload("res://assets/audio/sfx/swing/swing1.wav"),
		preload("res://assets/audio/sfx/swing/swing2.wav"),
		preload("res://assets/audio/sfx/swing/swing3.wav")
	],
	"defend": [
		preload("res://assets/audio/sfx/defend/defend.wav")
	],
	"hurt_player": [
		preload("res://assets/audio/sfx/hurt/player/01._damage_grunt_male.wav"),
		preload("res://assets/audio/sfx/hurt/player/02._damage_grunt_male.wav"),
		preload("res://assets/audio/sfx/hurt/player/03._damage_grunt_male.wav"),
		preload("res://assets/audio/sfx/hurt/player/04._damage_grunt_male.wav"),
		preload("res://assets/audio/sfx/hurt/player/05._damage_grunt_male.wav"),
		preload("res://assets/audio/sfx/hurt/player/06._damage_grunt_male.wav"),
		preload("res://assets/audio/sfx/hurt/player/07._damage_grunt_male.wav"),
		preload("res://assets/audio/sfx/hurt/player/08._damage_grunt_male.wav"),
		preload("res://assets/audio/sfx/hurt/player/09._damage_grunt_male.wav")
	],
	"damage_flesh": [
		preload("res://assets/audio/sfx/damage/flesh/1.wav")
	],
	"pickup_key": [
		preload("res://assets/audio/sfx/interact/pickup_key.wav")
	],
	"open_door": [
		preload("res://assets/audio/sfx/interact/open_door.ogg")
	]
}

func play_effect(position: Vector2, name: String):
	var audio_player = AudioStreamPlayer2D.new()
	if sfx.has(name):
		audio_player.stream = sfx[name].pick_random()
		get_tree().root.add_child(audio_player)
		audio_player.global_position = position
		audio_player.play()
		await audio_player.finished
		audio_player.queue_free()
