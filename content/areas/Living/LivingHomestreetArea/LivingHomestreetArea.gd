extends "res://content/areas/Street.gd"

export (NodePath) var leave_home_area_path
export (Vector2) var leave_home_player_position

export (NodePath) var leave_mom_area_path
export (Vector2) var leave_mom_player_position

func _ready():

	$LeaveHomeTriggerArea/LeaveHomeTrigger.target_area = get_node(leave_home_area_path)
	$LeaveHomeTriggerArea/LeaveHomeTrigger.new_player_position = leave_home_player_position

	$LeaveMomTriggerArea/LeaveMomTrigger.target_area = get_node(leave_mom_area_path)
	$LeaveMomTriggerArea/LeaveMomTrigger.new_player_position = leave_mom_player_position
