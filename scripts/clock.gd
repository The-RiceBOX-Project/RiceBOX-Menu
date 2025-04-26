extends Label

func _process(_delta: float) -> void:
	var hour = Time.get_datetime_dict_from_system().hour
	var mins = Time.get_datetime_dict_from_system().minute
	if hour < 10:
		hour = str("0" + str(hour))
		
	if mins < 10:
		mins = str("0" + str(mins))
	
	text = str(hour) + ":" + str(mins)
