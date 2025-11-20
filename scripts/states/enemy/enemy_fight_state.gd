extends State
class_name EnemyFightState

@export var enemy: Enemy = null
@export var animation_tree: AnimationTree = null
@export var attack_component: AttackComponent = null
@export var movement_component: MovementComponent = null
@export var hitbox_component: HitboxComponent = null

var playback: AnimationNodeStateMachinePlayback = null
var health_component: HealthComponent = null
var damage_received: bool = false

func _ready() -> void:
	playback = animation_tree.get("parameters/playback")
	if hitbox_component:
		health_component = hitbox_component.health_component

func _on_damage_received(damage: float) -> void:
	damage_received = true

func enter() -> void:
	movement_component.stop()
	if health_component:
		health_component.damage_received.connect(_on_damage_received)

func exit() -> void:
	if health_component:
		health_component.damage_received.disconnect(_on_damage_received)

func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	# Handle death
	if health_component and health_component.is_dead():
		transition.emit(self, "EnemyDeadState")
		return
	
	# Handle hurt
	if damage_received and not attack_component.is_attacking():
		damage_received = false
		transition.emit(self, "EnemyHurtState")
		return
	
	var to_target_dir = enemy.direction_to_target()
	var distance_to_target = enemy.distance_to_target()
	
	if distance_to_target > enemy.attack_distance:
		transition.emit(self, "EnemyChaseState")
		return
	
	if to_target_dir != movement_component.facing_direction:
		movement_component.flip_to_direction(to_target_dir)
	
	if not attack_component.get_attack_cooldown():
		attack_component.attack()
		if attack_component.is_attacking():
			var combo = attack_component.get_current_combo()
			playback.travel("Attack " + str(combo))
	else:
		transition.emit(self, "EnemyProtectState")
