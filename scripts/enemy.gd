extends CharacterBody2D
class_name Enemy

@export var target: Player = null
@export var agro_distance: float = 300.0
@export var attack_distance: float = 50.0
@export var min_distance_for_run_attack: float = 250.0
@export var start_run_attack_distance: float = 150.0

@export var enable_enemy_run_attack: bool = false

func distance_to_target() -> float:
	return abs(target.position.x - position.x)

func direction_to_target() -> float:
	return sign(target.position.x - position.x)
