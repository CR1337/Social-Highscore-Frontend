extends Node2D

export (NodePath) var leaveBottomAreaPath
export (Vector2) var leaveBottomPlayerPosition

export (NodePath) var leaveBusAreaPath
export (Vector2) var leaveBusPlayerPosition

func _ready():
	$LeaveBottomTrigger.targetArea = get_node(leaveBottomAreaPath)
	$LeaveBottomTrigger.newPlayerPosition = leaveBottomPlayerPosition
	
	$BusTrigger.targetArea = get_node(leaveBusAreaPath)
	$BusTrigger.newPlayerPosition = leaveBusPlayerPosition
	
