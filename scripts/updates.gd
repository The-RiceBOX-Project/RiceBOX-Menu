extends Control
@onready var fetch_updates = $fetch_updates
@onready var error_label = $error
var version_info = preload("res://scenes/update.tscn")
@onready var updates = $Updates/VBoxContainer
var get_releases_url = "https://api.github.com/repos/KNProNooob/RiceBOX/releases"


func _on_check_for_updates_pressed() -> void:
	for child in updates.get_children():
		updates.remove_child(child)
	fetch_updates.request(get_releases_url)
	


func _on_fetch_updates_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		error_label.text = "An error has occured, please check you internet connection and try again."
	else:
		error_label.text = ""
		var versions = JSON.parse_string(body.get_string_from_utf8())
		for version in versions:
			var node = version_info.instantiate()
			node.version = version.name
			node.date = version.published_at
			node.download_url = version.assets[0].browser_download_url
			updates.add_child(node)
		
