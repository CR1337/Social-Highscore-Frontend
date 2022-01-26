extends "res://content/areas/Street.gd"

export (NodePath) var leaveHomeAreaPath
export (Vector2) var leaveHomePlayerPosition

export (NodePath) var leaveMomAreaPath
export (Vector2) var leaveMomPlayerPosition

func _ready():

	$LeaveHomeTriggerArea/LeaveHomeTrigger.targetArea = get_node(leaveHomeAreaPath)
	$LeaveHomeTriggerArea/LeaveHomeTrigger.newPlayerPosition = leaveHomePlayerPosition	
	
	$LeaveMomTriggerArea/LeaveMomTrigger.targetArea = get_node(leaveMomAreaPath)
	$LeaveMomTriggerArea/LeaveMomTrigger.newPlayerPosition = leaveMomPlayerPosition
