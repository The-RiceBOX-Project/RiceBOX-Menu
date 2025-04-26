extends Button
signal clicked(key)


func _on_pressed() -> void:
	clicked.emit(text)
