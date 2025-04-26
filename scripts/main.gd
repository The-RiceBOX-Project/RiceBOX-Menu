extends Control

var previous_vert := 0
var previous_horz := 0
var previous_click := 0
var previous_show := 0
var controller_ready := false


func _on_arduino_data_recieved(myString: String) -> void:
	#print(myString)
	var data = myString.split(" ")
	var vert =  roundc(data[0])
	var horz =  roundc(data[1])
	var click = int(data[5])
	var show = int(data[4])
	
	if not controller_ready:
		if click == 0:
			controller_ready = true
	
	var sidev = KEY_DOWN if vert < 0 else KEY_UP
	if vert != 0 and (previous_vert == 0):
		var event = InputEventKey.new()
		event.keycode = sidev
		event.pressed = true
		Input.parse_input_event(event)
		
		event = InputEventKey.new()
		event.keycode = sidev
		event.pressed = false
		Input.parse_input_event(event)
	previous_vert = vert
	
	
	var sideh = KEY_LEFT if horz < 0 else KEY_RIGHT
	if horz != 0 and (previous_horz == 0):
		var event = InputEventKey.new()
		event.keycode = sideh
		event.pressed = true
		Input.parse_input_event(event)
		
		event = InputEventKey.new()
		event.keycode = sideh
		event.pressed = false
		Input.parse_input_event(event)
	previous_horz = horz
	
	
	if controller_ready:
		if click and (previous_click == 0):
			var event = InputEventKey.new()
			event.keycode = KEY_ENTER
			event.pressed = true
			Input.parse_input_event(event)
			
			event = InputEventKey.new()
			event.keycode = KEY_ENTER
			event.pressed = false
			Input.parse_input_event(event)
		previous_click = click
		
		if show and (previous_show == 0):
			var event := InputEventAction.new()
			event.action = "show"
			event.pressed = true
			Input.parse_input_event(event)
			
			event = InputEventAction.new()
			event.action = "show"
			event.pressed = false
			Input.parse_input_event(event)
		previous_show = show


func roundc(value: String) -> int:
	return floor(float(value) + 0.5)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_timeout_arduino_timeout() -> void:
	$arduino.process_mode = Node.PROCESS_MODE_ALWAYS
