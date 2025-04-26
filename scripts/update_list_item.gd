extends Control
var version
var date
var download_url
@onready var http_req = $HTTPRequest
@onready var update_text = get_node("../../../UpdatingText")
@onready var check_for_updates = get_node("../../../Check_for_updates")
@onready var download_completed = get_node("../../../DownloadCompleted")
@onready var updates_list = get_node("../../")
@onready var updates_button = get_node("../../../../Buttons/Updates")

func _ready() -> void:
	$Version.text = version
	$Date.text = date.replace("T", " ")
	$Date.text = $Date.text.replace("Z", "")
	var current_version = ProjectSettings.get_setting("application/config/version")
	if version == current_version:
		$Update.text = "Current"
		$Update.disabled = true
	if current_version.split(".")[0] > version.split(".")[0]:
		$Update.text = "Downgrade"
		return
	elif current_version.split(".")[0] == version.split(".")[0]:
		if current_version.split(".")[1] > version.split(".")[1]:
			$Update.text = "Downgrade"
			return
		elif current_version.split(".")[1] == version.split(".")[1]:
			if current_version.split(".")[2] > version.split(".")[2]:
				$Update.text = "Downgrade"

func _on_update_pressed() -> void:
	http_req.request(download_url)
	update_text.text = "Downloading version " + version + "..."
	update_text.show()
	updates_list.hide()
	check_for_updates.hide()
	updates_button.grab_focus()

func _on_http_request_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	print("aaa")
	if response_code != 200:
		print("Download failed")
		return
	var file = FileAccess.open("updates/menu", FileAccess.WRITE)
	file.store_buffer(body)
	file.close()
	update_text.hide()
	download_completed.get_node("Label").text = "Update " + version + " has been downloaded, please restart your console in order to apply it."
	download_completed.show()
	
