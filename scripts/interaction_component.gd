extends Area2D
class_name InterractionComponent

@export var inventory: InventoryComponent = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	_on_body_entered(area)

func _on_body_entered(body: Node2D):
	var owner_pos = inventory.inventory_owner.global_position
	if body.is_in_group("door_keys"):
		SfxManager.play_effect(owner_pos, "pickup_key")
		HudManager.float_text(owner_pos - Vector2(0.0, 80.0), "Door key collected", Color.YELLOW)
		inventory.add_item("door_key")
		body.queue_free()
	elif body.is_in_group("level_exit"):
		if inventory.count("door_key"):
			SfxManager.play_effect(owner_pos, "open_door")
			GameManager.load_next_level()
