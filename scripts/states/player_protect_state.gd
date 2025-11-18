extends State
class_name PlayerProtectState

@export var animation_tree: AnimationTree = null
@export var hitbox_component: HitboxComponent = null
var health_component: HealthComponent = null

var playback: AnimationNodeStateMachinePlayback = null
var attack_received: bool = false

func _ready() -> void:
	playback = animation_tree.get("parameters/playback")
	health_component = hitbox_component.health_component

func _on_attack_received(attack: Attack):
	attack_received = true
	attack.damage_multiplier = 0.0

func enter() -> void:
	hitbox_component.attack_received.connect(_on_attack_received)
	playback.travel("Protect")

func exit() -> void:
	hitbox_component.attack_received.disconnect(_on_attack_received)

func update(_delta: float) -> void:
	if health_component.is_dead():
		transition.emit(self, "DeadState")
	
	elif attack_received:
		transition.emit(self, "DefendState")
		attack_received = false
	
	elif not Input.is_action_pressed("protect"):
		transition.emit(self, "MoveState")

func physics_update(_delta: float) -> void:
	pass
