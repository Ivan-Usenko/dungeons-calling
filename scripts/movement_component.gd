extends Node2D
class_name MovementComponent

@export var target: CharacterBody2D = null
@export var direction_dependend: Node2D = null
@export var walk_speed: float = 150.0
@export var run_speed: float = 250.0
@export var jump_velocity: float = 200.0
@export var use_gravity: bool = true

var facing_direction: float = 1.0

func _move(speed: float, direction: float, dt: float):
	if target.is_on_floor():
		flip_to_direction(direction)
		target.velocity.x = direction * speed

func walk(direction: float, dt: float):
	_move(walk_speed, direction, dt)

func stop():
	_move(0.0, 0.0, 0.0)

func run(direction: float, dt: float):
	_move(run_speed, direction, dt)

func jump() -> bool:
	if target.is_on_floor():
		target.velocity.y -= jump_velocity
		return true
	
	return false

func _physics_process(delta: float) -> void:
	if use_gravity and not target.is_on_floor():
		target.velocity += target.get_gravity() * delta
	
	target.move_and_slide()

func flip_to_direction(direction: float):
	if direction > 0.0:
		facing_direction = 1.0
		direction_dependend.scale.x = facing_direction
		
	elif direction < 0.0:
		facing_direction = -1.0
		direction_dependend.scale.x = facing_direction
