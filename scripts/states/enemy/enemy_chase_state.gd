extends State
class_name EnemyChaseState

@export var enemy: Enemy = null
@export var animation_tree: AnimationTree = null
@export var movement_component: MovementComponent = null
@export var health_component: HealthComponent = null

var playback: AnimationNodeStateMachinePlayback = null
var damage_received: bool = false
var start_chase_distance: float = 0.0

func _ready() -> void:
	playback = animation_tree.get("parameters/playback")

func _on_damage_received(damage: float) -> void:
	damage_received = true

func enter() -> void:
	start_chase_distance = enemy.distance_to_target()
	playback.travel("Run")
	if health_component:
		health_component.damage_received.connect(_on_damage_received)

func exit() -> void:
	if health_component:
		health_component.damage_received.disconnect(_on_damage_received)

func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	var signed_distance = enemy.target.position.x - enemy.position.x
	var to_target_dir = sign(signed_distance)
	var distance_to_target = abs(signed_distance)
	
	# Handle death
	if health_component and health_component.is_dead():
		transition.emit(self, "EnemyDeadState")
		return
	
	# Handle hurt
	if damage_received:
		damage_received = false
		movement_component.stop()
		transition.emit(self, "EnemyHurtState")
		return
	
	if start_chase_distance >= enemy.min_distance_for_run_attack and\
	 distance_to_target <= enemy.start_run_attack_distance and\
	 enemy.enable_enemy_run_attack:
		transition.emit(self, "EnemyRunAttackState")
		return
	elif distance_to_target <= enemy.attack_distance:
		transition.emit(self, "EnemyFightState")
		return
	elif distance_to_target > enemy.agro_distance:
		movement_component.stop()
		transition.emit(self, "EnemyIdleState")
		return
	
	movement_component.run(to_target_dir, delta)
