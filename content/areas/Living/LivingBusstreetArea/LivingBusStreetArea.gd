extends Node2D

export (NodePath) var leaveBottomAreaPath
export (Vector2) var leaveBottomLeftPlayerPosition
export (Vector2) var leaveBottomRightPlayerPosition


func _ready():
	$LeaveBottomLeftTrigger.targetArea = get_node(leaveBottomAreaPath)
	$LeaveBottomLeftTrigger.newPlayerPosition = leaveBottomLeftPlayerPosition
	
	$LeaveBottomRightTrigger.targetArea = get_node(leaveBottomAreaPath)
	$LeaveBottomRightTrigger.newPlayerPosition = leaveBottomRightPlayerPosition
	
