extends Node2D
class_name HealthComponent

signal damage_received
signal healing_received
signal died

@export var max_health: float = 10.0

var health: float
var dead: bool = false

func _ready() -> void:
	health = max_health

func damage(attack_damage: float) -> void:
	if dead or attack_damage <= 0.0:
		return
	
	health = max(health - attack_damage, 0.0)
	damage_received.emit(attack_damage)
	if health <= 0.0:
		dead = true
		died.emit()

func heal(healing: float) -> void:
	if healing <= 0.0:
		return
	
	if not dead:
		healing_received.emit(healing)
		health = min(health + healing, max_health)

func get_max_health() -> float:
	return max_health

func get_health() -> float:
	return health

func is_dead() -> bool:
	return dead
