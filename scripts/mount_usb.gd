extends Node
var mount_dir = "mnt"
@onready var games_list = get_node("../Game_select")

func _ready():
	_on_timer_timeout()

func _on_timer_timeout() -> void:
	var lsblk = []
	OS.execute("lsblk", ["--json"], lsblk)
	var drives = JSON.parse_string(lsblk[0])
	
	for drive in drives.blockdevices:
		if drive.name.begins_with("sd"):
			if drive.children[0].mountpoints[0] == null:
				var drive_name = drive.children[0].name
				print(drive_name)
				OS.execute("sudo", ["mount", "/dev/" + drive.children[0].name, mount_dir])
				games_list.refresh()
			break
		
