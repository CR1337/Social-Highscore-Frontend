extends Node2D

export (NodePath) var leaveLeftAreaPath
export (Vector2) var leaveLeftPlayerPosition

export (NodePath) var leaveRightAreaPath
export (Vector2) var leaveRightPlayerPosition

export (NodePath) var leaveTopAreaPath
export (Vector2) var leaveTopPlayerPosition

export (NodePath) var leaveBottomAreaPath
export (Vector2) var leaveBottomPlayerPosition

func _ready():
	if leaveLeftAreaPath != "":
		$LeaveLeftTriggerArea/LeaveLeftTrigger.targetArea = get_node(leaveLeftAreaPath)
		$LeaveLeftTriggerArea/LeaveLeftTrigger.newPlayerPosition = leaveLeftPlayerPosition
	if leaveRightAreaPath != "":
		$LeaveRightTriggerArea/LeaveRightTrigger.targetArea = get_node(leaveRightAreaPath)
		$LeaveRightTriggerArea/LeaveRightTrigger.newPlayerPosition = leaveRightPlayerPosition
	if leaveTopAreaPath != "":
		$LeaveTopTriggerArea/LeaveTopTrigger.targetArea = get_node(leaveTopAreaPath)
		$LeaveTopTriggerArea/LeaveTopTrigger.newPlayerPosition = leaveTopPlayerPosition
	if leaveBottomAreaPath != "":
		$LeaveBottomTriggerArea/LeaveBottomTrigger.targetArea = get_node(leaveBottomAreaPath)
		$LeaveBottomTriggerArea/LeaveBottomTrigger.newPlayerPosition = leaveBottomPlayerPosition
