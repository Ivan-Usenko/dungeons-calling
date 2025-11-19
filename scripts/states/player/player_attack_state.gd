extends State
class_name PlayerAttackState

@export var animation_tree: AnimationTree = null
@export var attack_component: AttackComponent = null
@export var health_component: HealthComponent = null
@export var animations_prefix: String = ""

var playback: AnimationNodeStateMachinePlayback = null

func _ready() -> void:
	playback = animation_tree.get("parameters/playback")

func try_attack() -> bool:
	if Input.is_action_just_pressed("attack"):
		attack_component.attack()
	
	if not attack_component.is_attacking():
		transition.emit(self, "MoveState")
		return false
	return true

func enter() -> void:
	try_attack()

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	if health_component and health_component.is_dead():
		transition.emit(self, "DeadState")
		return
	
	if not try_attack():
		return
	
	var combo = attack_component.get_current_combo()
	playback.travel(animations_prefix + "Attack " + str(combo))
