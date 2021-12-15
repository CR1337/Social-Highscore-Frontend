extends Node2D

export (NodePath) var leaveLeftAreaPath
export (Vector2) var leaveLeftPlayerPosition

func _ready():
	$LeaveLeftTrigger.targetArea = leaveLeftAreaPath
	$LeaveLeftTrigger.newPlayerPosition = leaveLeftPlayerPosition
