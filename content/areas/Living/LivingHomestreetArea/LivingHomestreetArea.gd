extends "res://content/areas/Street.gd"

export (NodePath) var leave_home_area_path
export (Vector2) var leave_home_player_position

export (NodePath) var leave_mom_area_path
export (Vector2) var leave_mom_player_position

func _ready():

	$LeaveHomeTriggerArea/LeaveHomeTrigger.targetArea = get_node(leave_home_area_path)
	$LeaveHomeTriggerArea/LeaveHomeTrigger.newPlayerPosition = leave_home_player_position

	$LeaveMomTriggerArea/LeaveMomTrigger.targetArea = get_node(leave_mom_area_path)
	$LeaveMomTriggerArea/LeaveMomTrigger.newPlayerPosition = leave_mom_player_position
