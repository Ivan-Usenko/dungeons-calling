extends Area2D
class_name AttackArea

@export var weapon_component: WeaponComponent = null
@export var damage_multiplier: float = 1.0

var direction: float = 0.0

func _ready() -> void:
	area_entered.connect(_on_attack_hit)
	
func _on_attack_hit(area: Area2D) -> void:
	if area is not HitboxComponent:
		return
	
	var hitbox: HitboxComponent = area
	var attacker = weapon_component.wielder
	var victim = hitbox.hitbox_owner
	direction = sign((victim.position - attacker.position).x)
	
	print(victim.name, " received attack from ", attacker.name)
	
	var attack: Attack = Attack.new()
	attack.weapon = weapon_component
	attack.damage_multiplier = damage_multiplier
	attack.direction = direction
	hitbox.attack_received.emit(attack)
	
	var damage = attack.get_damage()
	print("Attack damage before protection: ", damage)
	if hitbox.armor_component:
		damage = max(damage - hitbox.armor_component.damage_reduction, 0.0)
	
	
	print("Attack damage after protection: ", damage)
	
	if not hitbox.health_component:
		return
	
	hitbox.health_component.damage(damage)
