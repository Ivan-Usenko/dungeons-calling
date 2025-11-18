extends State
class_name DefendState

@export var animation_tree: AnimationTree = null

var playback: AnimationNodeStateMachinePlayback = null

func _ready() -> void:
	playback = animation_tree.get("parameters/playback")

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Defend":
		transition.emit(self, "ProtectState")

func enter() -> void:
	playback.travel("Defend")
	animation_tree.animation_finished.connect(_on_animation_finished)

func exit() -> void:
	animation_tree.animation_finished.disconnect(_on_animation_finished)

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
