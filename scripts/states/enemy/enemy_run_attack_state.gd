extends State
class_name EnemyRunAttackState

@export var enemy: Enemy = null
@export var animation_tree: AnimationTree = null
@export var attack_component: AttackComponent = null
@export var movement_component: MovementComponent = null
@export var health_component: HealthComponent = null

var playback: AnimationNodeStateMachinePlayback = null
var damage_received: bool = false
var start_facing_direction: float = 0.0
var combo_finished: bool = false

func _ready() -> void:
	playback = animation_tree.get("parameters/playback")

func _on_combo_finished() -> void:
	combo_finished = true

func enter() -> void:
	playback.travel("Run")
	combo_finished = false
	start_facing_direction = movement_component.facing_direction
	attack_component.combo_finished.connect(_on_combo_finished)

func exit() -> void:
	attack_component.combo_finished.disconnect(_on_combo_finished)

func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	# Handle death
	if health_component and health_component.is_dead():
		transition.emit(self, "EnemyDeadState")
		return
	
	if combo_finished:
		var distance_to_target = enemy.distance_to_target()
		if distance_to_target > enemy.agro_distance:
			transition.emit(self, "EnemyIdleState")
		elif distance_to_target < enemy.attack_distance:
			transition.emit(self, "EnemyFightState")
		else:
			transition.emit(self, "EnemyChaseState")
		return
	
	movement_component.run(start_facing_direction, delta)
	
	attack_component.attack()
	if attack_component.is_attacking():
		var combo = attack_component.get_current_combo()
		playback.travel("RunAttack " + str(combo))
	
