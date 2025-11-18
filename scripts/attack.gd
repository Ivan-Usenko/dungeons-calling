extends Area2D
class_name Attack

@export var weapon_component: WeaponComponent = null
@export var damage_multiplier: float = 1.0


func get_damage() -> float:
	return weapon_component.base_damage * damage_multiplier
