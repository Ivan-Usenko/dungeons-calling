extends State
class_name PlayerMoveState

@export var animation_tree: AnimationTree = null
@export var movement_component: MovementComponent = null
@export var hitbox_component: HitboxComponent = null
var health_component: HealthComponent = null

var playback: AnimationNodeStateMachinePlayback = null

var direction: float = 0.0
var idle: bool = false
var walking: bool = false
var running: bool = false
var airborne: bool = false
var damage_received: bool = false

func _ready() -> void:
	playback = animation_tree.get("parameters/playback")
	health_component = hitbox_component.health_component

func _on_damage_received(damage: float) -> void:
	damage_received = true

func update_state() -> void:
	direction = Input.get_axis("move_left", "move_right")
	airborne = not movement_component.target.is_on_floor()
	
	var moving = bool(direction)
	var run_pressed = Input.is_action_pressed("run")
	idle = not moving
	walking = moving and not run_pressed
	running = moving and run_pressed

func update_animation() -> void:
	if walking:
		playback.travel("Walk")
	elif running:
		playback.travel("Run")
	elif idle:
		playback.travel("Idle")

func enter() -> void:
	health_component.damage_received.connect(_on_damage_received)
	update_state()
	update_animation()

func exit() -> void:
	health_component.damage_received.disconnect(_on_damage_received)

func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	update_state()
	
	# Handle death
	if health_component.is_dead():
		transition.emit(self, "DeadState")
		return
	
	# Handle movement
	if walking:
		movement_component.walk(direction, delta)
	elif running:
		movement_component.run(direction, delta)
	elif idle:
		movement_component.stop()
	
	# Handle jumping
	if Input.is_action_just_pressed("jump") or airborne:
		transition.emit(self, "JumpState")
		return
	
	# Handle attacking
	var attack = Input.is_action_just_pressed("attack")
	if attack and (idle or walking):
		movement_component.stop()
		transition.emit(self, "AttackState")
		return
	elif attack and running:
		transition.emit(self, "RunAttackState")
		return
	
	# Handle hurt
	if damage_received:
		damage_received = false
		movement_component.stop()
		transition.emit(self, "HurtState")
		return
	
	# Handle protect
	if Input.is_action_pressed("protect") and (idle or walking):
		movement_component.stop()
		transition.emit(self, "ProtectState")
		return
		
	update_animation()
