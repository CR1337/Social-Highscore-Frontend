extends "res://content/areas/Street.gd"

export (NodePath) var leave_store_area_path
export (Vector2) var leave_store_player_position

func _ready():

	$LeaveStoreTriggerArea/LeaveStoreTrigger.targetArea = get_node(leave_store_area_path)
	$LeaveStoreTriggerArea/LeaveStoreTrigger.newPlayerPosition = leave_store_player_position
