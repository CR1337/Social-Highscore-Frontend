extends Node2D

export (NodePath) var leaveRightAreaPath
export (Vector2) var leaveRightUpperPlayerPosition
export (Vector2) var leaveRightLowerPlayerPosition


func _ready():
	$LeaveRightUpperTrigger.targetArea = get_node(leaveRightAreaPath)
	$LeaveRightUpperTrigger.newPlayerPosition = leaveRightUpperPlayerPosition
	
	$LeaveRightLowerTrigger.targetArea = get_node(leaveRightAreaPath)
	$LeaveRightLowerTrigger.newPlayerPosition = leaveRightLowerPlayerPosition
