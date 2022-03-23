extends "res://content/areas/Street.gd"

export (NodePath) var leave_store_area_path
export (Vector2) var leave_store_player_position

func _ready():

	$LeaveStoreTriggerArea/LeaveStoreTrigger.target_area = get_node(leave_store_area_path)
	$LeaveStoreTriggerArea/LeaveStoreTrigger.new_player_position = leave_store_player_position
