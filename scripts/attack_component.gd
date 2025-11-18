extends Node2D
class_name AttackComponent

@export var combo_reset_time: float = 0.25
@export var full_combo_attack_cooldown: float = 0.5

var combo_attacks_count: int = 0
var current_combo: int = 0
var attacking: bool = false

var time_until_combo_reset: float = 0.0
var attack_cooldown: float = 0.0

## Allow to queue next attack in combo
## while previous attack still in progress
var can_perform_next_attack: bool = false

## Flag to perform next attack immediatly
## after last one finished
var perform_next_attack: bool = false

func _ready() -> void:
	combo_attacks_count = get_child_count()

func _process(delta: float) -> void:
	# Decrease attack cooldown if one is set
	if attack_cooldown > 0.0:
		attack_cooldown -= delta
	
	# Combo succesfully complited
	if not attacking and current_combo == combo_attacks_count:
		# Reset combo and start attack cooldown
		current_combo = 0
		attack_cooldown = full_combo_attack_cooldown
	
	# Combo in progress
	elif not attacking and current_combo > 0:
		# Reset combo if enough time passed between attacks
		time_until_combo_reset -= delta
		if time_until_combo_reset <= 0.0:
			current_combo = 0

func attack() -> void:
	if attack_cooldown > 0.0 or current_combo >= combo_attacks_count:
		return
	elif attacking and can_perform_next_attack:
		perform_next_attack = true
		return
	elif attacking:
		return
	
	attacking = true
	current_combo += 1

 ## This callback function should be called from attack animation
func _on_attack_end() -> void:
	can_perform_next_attack = false
	attacking = false
	time_until_combo_reset = combo_reset_time
	
	if perform_next_attack:
		perform_next_attack = false
		attack()

## This callback function should be called from attack animation
func _can_perform_next_attack() -> void:
	can_perform_next_attack = true

func is_attacking() -> bool:
	return attacking

## Return current amount attacks in a row
func get_current_combo() -> int:
	return current_combo
