extends Area2D
class_name HitboxComponent

signal attack_received

@export var health_component: HealthComponent = null
@export var armor_component: ArmorComponent = null

func _ready() -> void:
	area_entered.connect(_on_hitbox_area_entered)

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is not Attack:
		return
	
	var attack: Attack = area
	attack_received.emit(attack)
	
	var damage = attack.get_damage()
	if armor_component:
		damage = max(damage - armor_component.damage_reduction, 0.0)
	
	health_component.damage(damage)
