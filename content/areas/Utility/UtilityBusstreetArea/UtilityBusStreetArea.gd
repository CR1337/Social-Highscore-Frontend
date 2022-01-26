extends "res://content/areas/Street.gd"

export (NodePath) var leaveHospitalAreaPath
export (Vector2) var leaveHospitalPlayerPosition

export (NodePath) var leaveMallAreaPath
export (Vector2) var leaveMallPlayerPosition

export (NodePath) var BusOverlayPath

func _ready():

	$LeaveHospitalTriggerArea/LeaveHospitalTrigger.targetArea = get_node(leaveHospitalAreaPath)
	$LeaveHospitalTriggerArea/LeaveHospitalTrigger.newPlayerPosition = leaveHospitalPlayerPosition

	$LeaveMallTriggerArea/LeaveMallTrigger.targetArea = get_node(leaveMallAreaPath)
	$LeaveMallTriggerArea/LeaveMallTrigger.newPlayerPosition = leaveMallPlayerPosition
	
	$BusTriggerArea/BusTrigger.targetOverlay = get_node(BusOverlayPath)
