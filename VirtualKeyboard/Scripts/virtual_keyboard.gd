extends Control
@export var textBox : Control
var is_uppercase = false
var is_textbox_on_focus = false
var is_up = false

func _ready() -> void:
	for button in get_children():
		if button.name != "background" and button.name != "AnimationPlayer":
			button.clicked.connect(_on_button_clicked)
	


func _on_focus_entered():
	is_textbox_on_focus = true

func _on_focus_exited():
	is_textbox_on_focus = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and is_textbox_on_focus and !is_up:
		show()
		$AnimationPlayer.play("show")
		is_up = true
		await get_tree().create_timer(0.2).timeout
		$Space.grab_focus()


func _on_button_clicked(key):
	if key == "backspace":
		textBox.text = textBox.text.erase(textBox.text.length() - 1)
	elif key == "shift":
		print("shift")
		if is_uppercase:
			for button in get_children():
				if button.name != "background" and button.name != "AnimationPlayer" and button.text != "EXIT":
					button.text = button.text.to_lower()
			is_uppercase = false
		else:
			for button in get_children():
				if button.name != "background" and button.name != "AnimationPlayer" and button.text != "EXIT":
					button.text = button.text.to_upper()
			is_uppercase = true
	elif key == "EXIT":
		$AnimationPlayer.play_backwards("show")
		is_up = false
		textBox.grab_focus()
	else:
		textBox.text += key
