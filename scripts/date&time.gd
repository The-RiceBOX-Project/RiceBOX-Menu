extends Control
@onready var timeLabel = $VBoxContainer/VBoxContainer/Time


func show_current_time():
	timeLabel.text = get_node("../../Clock").text.replace(":", " : ")


func get_hours():
	return timeLabel.text.split(" : ")[0]
	
func get_mins():
	return timeLabel.text.split(" : ")[1]

func _on_hours_up_pressed() -> void:
	var hours = int(get_hours())
	hours += 1
	if hours > 23:
		hours = 0
	if hours < 10:
		timeLabel.text = "0" + str(hours) + " : " + get_mins()
	else:
		timeLabel.text = str(hours) + " : " + get_mins()


func _on_mins_up_pressed() -> void:
	var mins = int(get_mins())
	mins += 1
	if mins > 59:
		mins = 0
	if mins < 10:
		timeLabel.text = get_hours() + " : 0" + str(mins)
	else:
		timeLabel.text = get_hours() + " : " + str(mins)


func _on_hours_down_pressed() -> void:
	var hours = int(get_hours())
	hours -= 1
	if hours < 0:
		hours = 23
	if hours < 10:
		timeLabel.text = "0" + str(hours) + " : " + get_mins()
	else:
		timeLabel.text = str(hours) + " : " + get_mins()


func _on_mins_down_pressed() -> void:
	var mins = int(get_mins())
	mins -= 1
	if mins < 0:
		mins = 59
	if mins < 10:
		timeLabel.text = get_hours() + " : 0" + str(mins)
	else:
		timeLabel.text = get_hours() + " : " + str(mins)


func _on_set_pressed() -> void:
	OS.execute("sudo", ["date", "--set", '"' + timeLabel.text.replace(" : ", ":") + '"'])
