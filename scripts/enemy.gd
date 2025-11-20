extends CharacterBody2D
class_name Enemy

@export var target: Player = null
@export var agro_distance: float = 300.0
@export var attack_distance: float = 50.0
@export var min_distance_for_run_attack: float = 250.0
@export var start_run_attack_distance: float = 150.0
@export var enable_enemy_run_attack: bool = false

@onready var movement_component = $MovementComponent
@onready var health_component = $HealthComponent

func _ready() -> void:
	movement_component.landed.connect(_on_landing)
	health_component.damage_received.connect(_on_damage_received)

func _on_landing() -> void: 
	FootstepSoundManager.play_landing(global_position + Vector2(0.0, 8.0))

func _on_damage_received(damage: float) -> void:
	HudManager.float_text(global_position - Vector2(0.0, 32.0), str(damage), Color.RED)
	SfxManager.play_effect(global_position, "damage_bones")
	SfxManager.play_effect(global_position, "hurt_skeleton")

func _play_footstep() -> void:
	FootstepSoundManager.play_footstep(global_position + Vector2(0.0, 8.0))
	SfxManager.play_effect(global_position, "step_bone")

func _play_attack() -> void:
	SfxManager.play_effect(global_position, "swing")

func _play_defend() -> void:
	SfxManager.play_effect(global_position, "defend")

func distance_to_target() -> float:
	return abs(target.position.x - position.x)

func direction_to_target() -> float:
	return sign(target.position.x - position.x)
