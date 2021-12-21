extends Node2D

export (NodePath) var leaveBottomAreaPath
export (Vector2) var leaveBottomPlayerPosition


func _ready():
	$LeaveBottomTrigger.targetArea = get_node(leaveBottomAreaPath)
	$LeaveBottomTrigger.newPlayerPosition = leaveBottomPlayerPosition
	
