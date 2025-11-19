extends Node
class_name FSM

var states: Dictionary[String, State] = {}
var current_state: State = null

@export var initial_state: State = null

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(_on_child_transition)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _on_child_transition(state: State, new_state_name: String):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
