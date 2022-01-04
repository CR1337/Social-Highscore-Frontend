extends Node2D

export (NodePath) var leaveLeftAreaPath
export (Vector2) var leaveLeftPlayerPosition

export (NodePath) var leaveRightAreaPath
export (Vector2) var leaveRightPlayerPosition

export (NodePath) var leaveTopAreaPath
export (Vector2) var leaveTopPlayerPosition

export (NodePath) var leaveHomeAreaPath
export (Vector2) var leaveHomePlayerPosition

export (NodePath) var leaveMomAreaPath
export (Vector2) var leaveMomPlayerPosition

var active = true

func _ready():
	$LeaveLeftTrigger.targetArea = get_node(leaveLeftAreaPath)
	$LeaveLeftTrigger.newPlayerPosition = leaveLeftPlayerPosition
	
	$LeaveRightTrigger.targetArea = get_node(leaveRightAreaPath)
	$LeaveRightTrigger.newPlayerPosition = leaveRightPlayerPosition
	
	$LeaveTopTrigger.targetArea = get_node(leaveTopAreaPath)
	$LeaveTopTrigger.newPlayerPosition = leaveTopPlayerPosition

	$LeaveHomeTrigger.targetArea = get_node(leaveHomeAreaPath)
	$LeaveHomeTrigger.newPlayerPosition = leaveHomePlayerPosition	
	
	$LeaveMomTrigger.targetArea = get_node(leaveMomAreaPath)
	$LeaveMomTrigger.newPlayerPosition = leaveMomPlayerPosition	
