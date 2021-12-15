extends Node2D

export (NodePath) var leaveRightAreaPath
export (Vector2) var leaveRightPlayerPosition

func _ready():
	$LeaveRightTrigger.targetArea = leaveRightAreaPath
	$LeaveRightTrigger.newPlayerPosition = leaveRightPlayerPosition
