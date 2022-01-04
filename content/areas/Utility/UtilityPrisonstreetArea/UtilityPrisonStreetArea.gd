extends Node2D

export (NodePath) var leaveRightAreaPath
export (Vector2) var leaveRightPlayerPosition

export (NodePath) var leavePrisonAreaPath
export (Vector2) var leavePrisonPlayerPosition

func _ready():
	$LeaveRightTrigger.targetArea = get_node(leaveRightAreaPath)
	$LeaveRightTrigger.newPlayerPosition = leaveRightPlayerPosition

	$LeavePrisonTrigger.targetArea = get_node(leavePrisonAreaPath)
	$LeavePrisonTrigger.newPlayerPosition = leavePrisonPlayerPosition
