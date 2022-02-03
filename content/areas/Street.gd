extends Node2D

export (NodePath) var leave_left_area_path
export (Vector2) var leave_left_player_position

export (NodePath) var leave_right_area_path
export (Vector2) var leave_right_player_position

export (NodePath) var leave_top_area_path
export (Vector2) var leave_top_player_position

export (NodePath) var leave_bottom_area_path
export (Vector2) var leave_bottom_player_position

func _ready():
	if leave_left_area_path != "":
		$LeaveLeftTriggerArea/LeaveLeftTrigger.target_area = get_node(leave_left_area_path)
		$LeaveLeftTriggerArea/LeaveLeftTrigger.new_player_position = leave_left_player_position
	if leave_right_area_path != "":
		$LeaveRightTriggerArea/LeaveRightTrigger.target_area = get_node(leave_right_area_path)
		$LeaveRightTriggerArea/LeaveRightTrigger.new_player_position = leave_right_player_position
	if leave_top_area_path != "":
		$LeaveTopTriggerArea/LeaveTopTrigger.target_area = get_node(leave_top_area_path)
		$LeaveTopTriggerArea/LeaveTopTrigger.new_player_position = leave_top_player_position
	if leave_bottom_area_path != "":
		$LeaveBottomTriggerArea/LeaveBottomTrigger.target_area = get_node(leave_bottom_area_path)
		$LeaveBottomTriggerArea/LeaveBottomTrigger.new_player_position = leave_bottom_player_position
