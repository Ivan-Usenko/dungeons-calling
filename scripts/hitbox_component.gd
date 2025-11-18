extends Area2D
class_name HitboxComponent

signal attack_received

@export var hitbox_owner: Node2D = null
@export var health_component: HealthComponent = null
@export var armor_component: ArmorComponent = null
