extends State
class_name EnemyProtectState

@export var enemy: Enemy = null
@export var animation_tree: AnimationTree = null
@export var attack_component: AttackComponent = null
@export var hitbox_component: HitboxComponent = null
@export var movement_component: MovementComponent = null
@export var number_of_blocks: int = 1
@export var block_cooldown: float = 5.0
var health_component: HealthComponent = null

var playback: AnimationNodeStateMachinePlayback = null
var blocked_count: int = 0
var attack_received: bool = false
var attack_blocked: bool = false
var start_block_cooldown_time: int = 0

func _ready() -> void:
	playback = animation_tree.get("parameters/playback")
	health_component = hitbox_component.health_component

func update_block_cooldown() -> void:
	if blocked_count >= number_of_blocks:
		var cur_time = Time.get_ticks_msec()
		if ((cur_time - start_block_cooldown_time) / 1000.0) >= block_cooldown:
			blocked_count = 0

func _on_attack_received(attack: Attack):
	attack_received = true
	
	attack_blocked = attack.direction != movement_component.facing_direction
	attack_blocked = attack_blocked and (blocked_count < number_of_blocks)
	
	if attack_blocked:
		attack.damage_multiplier = 0.0
		blocked_count += 1
		
		if blocked_count >= number_of_blocks:
			start_block_cooldown_time = Time.get_ticks_msec()

func enter() -> void:
	update_block_cooldown()
	hitbox_component.attack_received.connect(_on_attack_received)
	playback.travel("Idle")

func exit() -> void:
	hitbox_component.attack_received.disconnect(_on_attack_received)

func update(_delta: float) -> void:
	if health_component.is_dead():
		transition.emit(self, "EnemyDeadState")
		return
	
	if attack_received:
		attack_received = false
		if not attack_blocked:
			transition.emit(self, "EnemyHurtState")
			return
	
	update_block_cooldown()
	
	var distance_to_target = enemy.distance_to_target()
	var max_bloks_reached = blocked_count >= number_of_blocks
	var to_target_dir = enemy.direction_to_target()
	
	if (to_target_dir != movement_component.facing_direction):
		movement_component.flip_to_direction(to_target_dir)
	
	if not attack_component.get_attack_cooldown():
		transition.emit(self, "EnemyFightState")
		return
	
	if max_bloks_reached:
		playback.travel("Idle")
	else:
		playback.travel("Protect")

func physics_update(_delta: float) -> void:
	pass
