extends TileMapLayer

func _ready() -> void:
	FootstepSoundManager.tilemaps.push_back(self)
