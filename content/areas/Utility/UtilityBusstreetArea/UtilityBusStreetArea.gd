extends Node2D

export (NodePath) var leaveLeftAreaPath
export (Vector2) var leaveLeftPlayerPosition

export (NodePath) var leaveHospitalAreaPath
export (Vector2) var leaveHospitalPlayerPosition

export (NodePath) var leaveMallAreaPath
export (Vector2) var leaveMallPlayerPosition

export (NodePath) var BusOverlayPath

func _ready():
	$LeaveLeftTrigger.targetArea = get_node(leaveLeftAreaPath)
	$LeaveLeftTrigger.newPlayerPosition = leaveLeftPlayerPosition

	$LeaveHospitalTrigger.targetArea = get_node(leaveHospitalAreaPath)
	$LeaveHospitalTrigger.newPlayerPosition = leaveHospitalPlayerPosition

	$LeaveMallTrigger.targetArea = get_node(leaveMallAreaPath)
	$LeaveMallTrigger.newPlayerPosition = leaveMallPlayerPosition
	
	$BusTrigger.targetOverlay = get_node(BusOverlayPath)
	
