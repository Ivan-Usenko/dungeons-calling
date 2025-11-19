extends State
class_name EnemyIdleState

@export var enemy: Enemy = null
@export var animation_tree: AnimationTree = null
@export var health_component: HealthComponent = null

var playback: AnimationNodeStateMachinePlayback = null
var damage_received: bool = false

func _ready() -> void:
	playback = animation_tree.get("parameters/playback")

func _on_damage_received(damage: float) -> void:
	damage_received = true

func enter() -> void:
	playback.travel("Idle")
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
		transition.emit(self, "DeadState")
		return
	
	# Handle hurt
	if damage_received:
		damage_received = false
		transition.emit(self, "EnemyHurtState")
		return
	
	var distance_to_target = abs(enemy.target.position.x - enemy.position.x)
	if distance_to_target <= enemy.agro_distance:
		transition.emit(self, "EnemyChaseState")
		return
