extends Control
var config = ConfigFile.new()
@export var image : Resource

func _ready() -> void:
	$Image.texture = image

func show_outline():
	$SelectedOutline.show()

func hide_outline():
	$SelectedOutline.hide()


func _on_focus_focus_entered() -> void:
	show_outline()


func _on_focus_exited() -> void:
	hide_outline()
	

func _on_focus_pressed() -> void:
	get_tree().get_first_node_in_group("Background").texture = $Image.texture
	config.load("user://selected_background.txt")
	config.set_value("background", "background", $Image.texture)
	config.save("user://selected_background.txt")
