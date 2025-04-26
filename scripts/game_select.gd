extends Control
var games_folder = "games"
var mnt_folder = "mnt"

var selected = 1
var game_num = 1
var slide = 445

@onready var Game_button = preload("res://scenes/game_button.tscn")

@onready var Dir_select = get_node("../Dir_select")
@onready var game_buttons = $HBoxContainer
@onready var game_details_page = get_node("../Game_details")


func _ready() -> void:
	add_buttons()


func _input(event: InputEvent) -> void:
	if !get_node("../Game_details").visible:
		if event.is_action_pressed("ui_right") and (selected+1 != game_num):
			selected += 1
			reselect(1)
			scroll(1)
		elif event.is_action_pressed("ui_left") and (selected-1) != 0:
			selected -= 1
			reselect(-1)
			scroll(-1)
		elif event.is_action_pressed("show"):
			get_node("../Settings/AnimationPlayer").play("summon")
			get_tree().paused = true
	
	if event.is_action_pressed("ui_accept"):
		if game_buttons.get_child(selected-1) != null:
			game_buttons.get_child(selected-1)._on_pressed()



func add_buttons() -> void:
	game_num = 1
	
	for game in DirAccess.get_directories_at(games_folder):
		var node = Game_button.instantiate()
		node.game_path = games_folder + "/" + game
		game_buttons.add_child(node)
		node.connect("game_selected", game_details_page._on_game_selected)
		node.add_game_number(game_num, selected)
		game_num += 1
	
	for game in DirAccess.get_directories_at(mnt_folder):
		if DirAccess.get_files_at(mnt_folder + "/" + game).has("manifest.json"):
			for game_on_disk in game_buttons.get_children():
				if game_on_disk.game_path.lstrip(games_folder + "/") == game:
					game_on_disk.has_an_update = true
					return
			
			var node = Game_button.instantiate()
			node.game_path = mnt_folder + "/" + game
			node.is_on_usb = true
			game_buttons.add_child(node)
			node.connect("game_selected", game_details_page._on_game_selected)
			node.add_game_number(game_num, selected)
			game_num += 1


func _on_back_pressed() -> void:
	hide()
	Dir_select.show()


func refresh():
	for child in game_buttons.get_children():
		game_buttons.remove_child(child)
	add_buttons()

func reselect(direction) -> void:
	for game in game_buttons.get_children():
		game.reselect(selected, direction)

func scroll(dir):
	var anim: Animation = $Slide.get_animation("slide")
	anim.track_set_key_value(0, 0, Vector2(game_buttons.position.x, game_buttons.position.y))
	slide += (356*-dir)
	anim.track_set_key_value(0, 1, Vector2(slide, game_buttons.position.y))
	$Slide.stop()
	$Slide.play("slide")
