extends CanvasLayer

signal transition_finised

@onready var color_rect = $ColorRect
@onready var anim_player = $AnimationPlayer

func _ready() -> void:
	color_rect.visible = false
	anim_player.animation_finished.connect(_on_anim_finished)

func _on_anim_finished(anim_name) -> void:
	if anim_name == "FadeOut":
		transition_finised.emit()
		anim_player.play("FadeIn")
	elif anim_name == "FadeIn":
		color_rect.visible = false

func transition():
	color_rect.visible = true
	anim_player.play("FadeOut")
