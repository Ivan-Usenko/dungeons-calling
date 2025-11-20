extends CharacterBody2D
class_name Player

@onready var movement_component = $MovementComponent
@onready var health_component = $HealthComponent

func _ready() -> void:
	movement_component.landed.connect(_on_landing)
	health_component.damage_received.connect(_on_damage_received)

func _on_landing() -> void: 
	FootstepSoundManager.play_landing(global_position + Vector2(0.0, 8.0))

func _on_damage_received(_damage: float) -> void:
	SfxManager.play_effect(global_position, "damage_flesh")
	SfxManager.play_effect(global_position, "hurt_player")

func _play_footstep() -> void:
	FootstepSoundManager.play_footstep(global_position + Vector2(0.0, 8.0))

func _play_attack() -> void:
	SfxManager.play_effect(global_position, "swing")

func _play_defend() -> void:
	SfxManager.play_effect(global_position, "defend")
