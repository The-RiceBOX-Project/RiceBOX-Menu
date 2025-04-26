extends Control

var internet = preload("res://scenes/i_button.tscn")
var netName: String = ""



func _on_search_pressed() -> void:
	$Results.text = "Searching..."
	await get_tree().create_timer(0.2).timeout
	
	var output = []
	var exit_code = OS.execute("nmcli", ["dev", "wifi", "list"], output, true)
	
	for i in $Internets/VBoxContainer.get_children():
		i.queue_free()
	
	var processed: Array[String] = []
	for line:String in output:
		var keys: PackedStringArray = line.split(" ")
		for key in keys:
			if key.is_empty() or key == "\n" or key == "\n*": continue
			processed.append(key)
	
	var j = 0
	var results = 0
	while(!processed[0].contains(":")): processed.pop_front()
	for i in range(processed.size()):
		var BSSID = processed[j]
		var SSID = processed[j+1]
		while(!processed[j+5].contains("bit/s")):
			j+=1
			SSID += " " + processed[j+1]
		var RATE = processed[j+4] + " " + processed[j+5]
		var SIGNAL = processed[j+6]
		var BARS = processed[j+7]
		
		var node = internet.instantiate()
		node.setup(SSID, RATE, SIGNAL, BARS, BSSID)
		$Internets/VBoxContainer.add_child(node)
		
		match BARS.count("_"):
			0: node.modulate = Color.hex(0x2ba0b3ff)
			1: node.modulate = Color.hex(0x27a369ff)
			2: node.modulate = Color.hex(0xa3724cff)
			3: node.modulate = Color.hex(0xff0019ff)
		
		j+=7
		while(!processed[j].contains(":")): 
			j+=1
			if j == processed.size(): break
		if j == processed.size():
			results = i
			break
	
	$Results.text = str(results) + " results"


func connect_to(SSID: String):
	$Popup.show()
	$Popup/Name.text = "SSID: " + SSID
	$Popup/PassField.clear()
	netName = SSID
	$Popup/Anim.play("appear")
	await $Popup/Anim.animation_finished
	$Popup/Back.grab_focus()


func _on_back_pressed() -> void:
	$Popup/Status.text = ""
	$InternetButtons/Search.grab_focus()
	$Popup/Anim.play_backwards("appear")
	await $Popup/Anim.animation_finished
	$Popup.hide()


func _on_pass_field_gui_input(event: InputEvent) -> void:
	if event.keycode == KEY_UP and event.pressed:
		$Popup/Back.grab_focus()
	elif event.keycode == KEY_DOWN and event.pressed:
		$Popup/Enter.grab_focus()


func _on_enter_pressed() -> void:
	$Popup/Status.self_modulate = Color(1,1,1,1)
	$Popup/Status.text = "Connecting..."
	await get_tree().create_timer(0.2).timeout
	
	netName = "\"" + netName + "\""
	var password = $Popup/PassField.text
	password = "\"" + password + "\""
	
	var output = []
	var exit_code = OS.execute("nmcli", ["dev", "wifi", "connect", netName, "password", password], output, true)
	if exit_code == 1:
		$Popup/Status.text = "Couldn't connect to network!"
		$Popup/Status.self_modulate = Color(1,0,0,1)
	else:
		$Popup/Status.text = "Success!"
		$Popup/Status.self_modulate = Color(0,1,0,1)
		_on_refresh_timeout()


func _on_disconnect_pressed() -> void:
	var output = []
	var connec: String = $Status.text
	connec = connec.erase(0, connec.find("(")+1)
	connec = connec.erase(connec.length()-1, 1)
	connec = "\"" + connec + "\""
	var exit_code = OS.execute("nmcli", ["connection", "down", connec], output, true)
	_on_refresh_timeout()


func _on_refresh_timeout() -> void:
	var output = []
	var exit_code = OS.execute("nmcli", ["-t", "-f", "name", "connection", "show", "--active"], output, true)
	output = String(output[0])
	output = output.split("\n")
	
	for i: String in output:
		if i.strip_edges() == "lo" or i.is_empty(): continue
		else:
			$Status.text = "Status: Connected (" + i + ")"
			$InternetButtons/Disconnect.disabled = false
			return
	
	$Status.text = "Status: Disconnected"
	$InternetButtons/Disconnect.disabled = true
