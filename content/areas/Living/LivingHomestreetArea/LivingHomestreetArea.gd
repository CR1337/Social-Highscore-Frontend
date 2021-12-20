extends Node2D

export (NodePath) var leaveLeftAreaPath
export (Vector2) var leaveLeftUpperPlayerPosition
export (Vector2) var leaveLeftLowerPlayerPosition

export (NodePath) var leaveRightAreaPath
export (Vector2) var leaveRightUpperPlayerPosition
export (Vector2) var leaveRightLowerPlayerPosition

export (NodePath) var leaveTopAreaPath
export (Vector2) var leaveTopLeftPlayerPosition
export (Vector2) var leaveTopRightPlayerPosition


func _ready():
	$LeaveLeftUpperTrigger.targetArea = get_node(leaveLeftAreaPath)
	$LeaveLeftUpperTrigger.newPlayerPosition = leaveLeftUpperPlayerPosition
	
	$LeaveLeftLowerTrigger.targetArea = get_node(leaveLeftAreaPath)
	$LeaveLeftLowerTrigger.newPlayerPosition = leaveLeftLowerPlayerPosition
	
	$LeaveRightUpperTrigger.targetArea = get_node(leaveRightAreaPath)
	$LeaveRightUpperTrigger.newPlayerPosition = leaveRightUpperPlayerPosition
	
	$LeaveRightLowerTrigger.targetArea = get_node(leaveRightAreaPath)
	$LeaveRightLowerTrigger.newPlayerPosition = leaveRightLowerPlayerPosition
	
	$LeaveTopLeftTrigger.targetArea = get_node(leaveTopAreaPath)
	$LeaveTopLeftTrigger.newPlayerPosition = leaveTopLeftPlayerPosition
	
	$LeaveTopRightTrigger.targetArea = get_node(leaveTopAreaPath)
	$LeaveTopRightTrigger.newPlayerPosition = leaveTopRightPlayerPosition
	
