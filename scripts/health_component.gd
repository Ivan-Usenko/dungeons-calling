extends Node2D
class_name HealthComponent

signal damage_received
signal healing_received
signal died

@export var max_health: float = 10.0

var anim_player: AnimationPlayer
var health_bar: TextureProgressBar

var health: float
var dead: bool = false

func _ready() -> void:
	anim_player = get_node_or_null("AnimationPlayer")
	health_bar = get_node_or_null("HealthBar")
	health = max_health
	
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health

func update_health_bar() -> void:
	if health_bar and not dead:
		health_bar.value = health
	elif health_bar and dead:
		health_bar.visible = false

func damage(attack_damage: float) -> void:
	if dead or attack_damage <= 0.0:
		return
	
	health = max(health - attack_damage, 0.0)
	if anim_player:
		anim_player.play("HurtTint")
	damage_received.emit(attack_damage)
	if health <= 0.0:
		dead = true
		died.emit()
	
	update_health_bar()

func heal(healing: float) -> void:
	if healing <= 0.0:
		return
	
	if not dead:
		healing_received.emit(healing)
		health = min(health + healing, max_health)
	
	update_health_bar()

func get_max_health() -> float:
	return max_health

func get_health() -> float:
	return health

func is_dead() -> bool:
	return dead
