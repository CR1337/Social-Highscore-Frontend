extends "res://content/areas/Street.gd"

export (NodePath) var leave_jobcenter_area_path
export (Vector2) var leave_jobcenter_player_position


func _ready():

	$LeaveJobcenterTriggerArea/LeaveJobcenterTrigger.targetArea = get_node(leave_jobcenter_area_path)
	$LeaveJobcenterTriggerArea/LeaveJobcenterTrigger.newPlayerPosition = leave_jobcenter_player_position
