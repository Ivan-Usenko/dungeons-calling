extends Node2D
class_name InventoryComponent

@export var inventory_owner: Node2D = null
var inventory: Array[String] = []

func add_item(item: String):
	inventory.append(item)

func remove_item(item: String):
	inventory.remove_at(inventory.find(item))

func count(item: String) -> int:
	return inventory.count(item)
