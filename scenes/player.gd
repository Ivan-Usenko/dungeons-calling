extends CharacterBody2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		var attack: Attack = Attack.new()
		var weapon: WeaponComponent = WeaponComponent.new()
		weapon.base_damage = 15.0
		attack.weapon_component = weapon
		$DirectionDependend/HitboxComponent._on_hitbox_area_entered(attack)
