extends Node2D

export (NodePath) var leaveBottomAreaPath
export (Vector2) var leaveBottomPlayerPosition

export (NodePath) var leaveLeftAreaPath
export (Vector2) var leaveLeftPlayerPosition

export (NodePath) var leaveTopAreaPath
export (Vector2) var leaveTopPlayerPosition

func _ready():
	$LeaveBottomTrigger.targetArea = get_node(leaveBottomAreaPath)
	$LeaveBottomTrigger.newPlayerPosition = leaveBottomPlayerPosition
	
	$LeaveLeftTrigger.targetArea = get_node(leaveLeftAreaPath)
	$LeaveLeftTrigger.newPlayerPosition = leaveLeftPlayerPosition
	
	$LeaveTopTrigger.targetArea = get_node(leaveTopAreaPath)
	$LeaveTopTrigger.newPlayerPosition = leaveTopPlayerPosition