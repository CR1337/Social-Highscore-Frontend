extends "res://content/areas/Street.gd"

export (NodePath) var leaveJobcenterAreaPath
export (Vector2) var leaveJobcenterPlayerPosition


func _ready():

	$LeaveJobcenterTriggerArea/LeaveJobcenterTrigger.targetArea = get_node(leaveJobcenterAreaPath)
	$LeaveJobcenterTriggerArea/LeaveJobcenterTrigger.newPlayerPosition = leaveJobcenterPlayerPosition
