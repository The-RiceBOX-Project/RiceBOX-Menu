extends TextureButton

var game_number: int
@export var game_path : String
@export var is_on_usb = false
var has_an_update = false
signal game_selected(game_path, is_on_usb)


func _ready() -> void:
	if is_on_usb:
		$USB.show()
	texture_normal = ImageTexture.create_from_image(Image.load_from_file(game_path + "/icon.png"))


func _on_pressed() -> void:
	game_selected.emit(game_path, is_on_usb)


func add_game_number(number, selected):
	game_number = number
	if number == selected: return
	if abs(number-selected) == 1:
		modulate = Color(1,1,1,0.5)
		$Selection.play("appear")

func reselect(selected, dir):
	if game_number == selected:
		$Selection.play_backwards("unselect")
		return
	
	if dir == 1: #if we move right
		if game_number-selected == 1:
			$Selection.play("appear")
		elif game_number-selected == -1:
			$Selection.play("unselect")
		elif abs(game_number-selected) == 2:
			$Selection.play_backwards("appear")
	else: #if we move left
		if game_number-selected == 1:
			$Selection.play("unselect")
		elif game_number-selected == -1:
			$Selection.play("appear")
		elif abs(game_number-selected) == 2:
			$Selection.play_backwards("appear")
