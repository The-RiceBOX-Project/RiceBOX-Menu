extends Control


func setup(nname, speed, ssignal, bars, bssid) -> void:
	$Name.text = nname
	$Speed.text = speed
	$Signal.text = ssignal
	$Bars.text = bars
	$BSSID.text = bssid


func _on_button_pressed() -> void:
	get_node("../../../").connect_to($Name.text)
