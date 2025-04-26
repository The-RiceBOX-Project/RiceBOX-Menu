extends Control


func _on_shutdown_pressed() -> void:
	OS.execute("poweroff", [])


func _on_restart_pressed() -> void:
	OS.execute("reboot", [])
