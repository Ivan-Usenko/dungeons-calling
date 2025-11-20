extends Node

func float_text(position: Vector2, text: String, color: Color) -> void:
	var label = Label.new()
	label.text = text
	label.z_index = 5
	label.label_settings = LabelSettings.new()
	label.label_settings.font_color = color
	label.label_settings.font_size = 16
	label.label_settings.outline_color = Color.BLACK
	label.label_settings.outline_size = 5
	
	call_deferred("add_child", label)
	
	await label.resized
	label.global_position = position - label.size / 2.0
	
	var tween = get_tree().create_tween()
	tween.tween_property(
		label, "position:y", label.position.y - 32.0, 1.0
	).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	label.queue_free()
