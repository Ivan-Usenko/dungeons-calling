extends Node2D
class_name PlayerControlComponent

@export var movement_component: MovementComponent = null
@export var attack_component: AttackComponent = null
@export var animation_tree: AnimationTree = null

var state_machine: AnimationNodeStateMachinePlayback = null

var airborne: bool = false
var moving: bool = false
var run_pressed: bool = false
var attacking: bool = false

func _ready() -> void:
	state_machine = animation_tree.get("parameters/playback")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and not airborne:
		attack_component.attack()
	
	attacking = attack_component.is_attacking()
	
	# Receive input from user
	var direction = Input.get_axis("move_left", "move_right") * float(not attacking)
	moving = bool(direction)
	run_pressed = Input.is_action_pressed("run")
	
	# Handle moving
	if run_pressed:
		movement_component.run(direction, delta)
	else:
		movement_component.walk(direction, delta)
	
	# Handle jumping
	airborne = not movement_component.target.is_on_floor()
	if Input.is_action_just_pressed("jump"):
		airborne = movement_component.jump() or airborne
	
	# Change animation depending on state
	if airborne:
		state_machine.travel("Jump")
	elif attacking:
		state_machine.travel("Attack " + str(attack_component.current_combo))
	elif moving and run_pressed:
		state_machine.travel("Run")
	elif moving and not run_pressed:
		state_machine.travel("Walk")
	elif not moving:
		state_machine.travel("Idle")
