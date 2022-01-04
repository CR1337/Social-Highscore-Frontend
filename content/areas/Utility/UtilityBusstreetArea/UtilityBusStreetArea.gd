extends Node2D

export (NodePath) var leaveLeftAreaPath
export (Vector2) var leaveLeftPlayerPosition

export (NodePath) var leaveHospitalAreaPath
export (Vector2) var leaveHospitalPlayerPosition

export (NodePath) var BusOverlayPath

func _ready():
	$LeaveLeftTrigger.targetArea = get_node(leaveLeftAreaPath)
	$LeaveLeftTrigger.newPlayerPosition = leaveLeftPlayerPosition

	$LeaveHospitalTrigger.targetArea = get_node(leaveHospitalAreaPath)
	$LeaveHospitalTrigger.newPlayerPosition = leaveHospitalPlayerPosition
	
	$BusTrigger.targetOverlay = get_node(BusOverlayPath)
	
