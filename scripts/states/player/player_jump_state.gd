extends State
class_name PlayerJumpState

@export var animation_tree: AnimationTree = null
@export var movement_component: MovementComponent = null

var playback: AnimationNodeStateMachinePlayback = null
var jumped: bool = false

func _ready() -> void:
	playback = animation_tree.get("parameters/playback")

func enter() -> void:
	jumped = movement_component.jump()
	playback.travel("Jump")

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	var airborne = not movement_component.target.is_on_floor() or jumped
	
	if not airborne:
		transition.emit(self, "MoveState")
	
	if jumped:
		jumped = false
