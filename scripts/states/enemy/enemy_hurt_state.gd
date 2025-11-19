extends State
class_name EnemyHurtState

@export var enemy: Enemy = null
@export var animation_tree: AnimationTree = null
@export var attack_component: AttackComponent = null

var playback: AnimationNodeStateMachinePlayback = null

func _ready() -> void:
	playback = animation_tree.get("parameters/playback")

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Hurt":
		var distance_to_target = abs(enemy.target.position.x - enemy.position.x)
		if distance_to_target > enemy.agro_distance:
			transition.emit(self, "EnemyIdleState")
		elif distance_to_target < enemy.attack_distance:
			transition.emit(self, "EnemyFightState")
		else:
			transition.emit(self, "EnemyChaseState")

func enter() -> void:
	playback.travel("Hurt")
	animation_tree.animation_finished.connect(_on_animation_finished)

func exit() -> void:
	animation_tree.animation_finished.disconnect(_on_animation_finished)

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
