extends State
class_name DeadState

@export var animation_tree: AnimationTree = null
@export var movement_component: MovementComponent = null

var playback: AnimationNodeStateMachinePlayback = null

func _ready() -> void:
	playback = animation_tree.get("parameters/playback")

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Dead":
		animation_tree.animation_finished.disconnect(_on_animation_finished)

func enter() -> void:
	movement_component.stop()
	playback.travel("Dead")
	animation_tree.animation_finished.connect(_on_animation_finished)

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
