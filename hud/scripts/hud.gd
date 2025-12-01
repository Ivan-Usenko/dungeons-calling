extends CanvasLayer

@export var player: Player = null

@onready var hp_bar: TextureProgressBar = $MarginContainer/VBoxContainer/HpBar
@onready var hp_bar_value_label: Label = $MarginContainer/VBoxContainer/HpBar/CenterContainer/ValueLable
@onready var key_indicator: TextureRect = $MarginContainer/VBoxContainer/KeyIndicator

func _ready() -> void:
	await player.ready
	
	_update_hp_bar()
	player.health_component.damage_received.connect(_on_player_damage_received)
	player.health_component.damage_received.connect(_on_player_heal_received)
	
	player.inventory_component.item_added.connect(_on_item_added)
	
func _update_hp_bar():
	var max_health = player.health_component.get_max_health()
	var cur_health = player.health_component.get_health()
	
	hp_bar.max_value = max_health
	hp_bar.value = cur_health
	hp_bar_value_label.text = str(int(cur_health)) + "/" + str(int(max_health))
	hp_bar_value_label.size = hp_bar_value_label.get_minimum_size()

func _on_player_damage_received(_damage: float):
	_update_hp_bar()

func _on_player_heal_received(_heal: float):
	_update_hp_bar()

func _on_item_added(item: String):
	if item == "door_key":
		key_indicator.modulate = Color.WHITE
