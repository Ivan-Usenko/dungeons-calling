extends Area2D
class_name HitboxComponent

signal attack_received

@export var hitbox_owner: Node2D = null
@export var health_component: HealthComponent = null
@export var armor_component: ArmorComponent = null

func _on_hitbox_entered(body: Node2D):
	if health_component:
		health_component.damage(health_component.get_health())

func _ready() -> void:
	body_entered.connect(_on_hitbox_entered)
