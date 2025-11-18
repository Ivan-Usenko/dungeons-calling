extends Node
class_name Attack

var weapon: WeaponComponent
var damage_multiplier: float
var direction: float

func get_damage() -> float:
	return weapon.base_damage * damage_multiplier
