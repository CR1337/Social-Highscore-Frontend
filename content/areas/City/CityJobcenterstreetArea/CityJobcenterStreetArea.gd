extends "res://content/areas/Street.gd"

export (NodePath) var leave_jobcenter_area_path
export (Vector2) var leave_jobcenter_player_position


func _ready():

	$LeaveJobcenterTriggerArea/LeaveJobcenterTrigger.target_area = get_node(leave_jobcenter_area_path)
	$LeaveJobcenterTriggerArea/LeaveJobcenterTrigger.new_player_position = leave_jobcenter_player_position
