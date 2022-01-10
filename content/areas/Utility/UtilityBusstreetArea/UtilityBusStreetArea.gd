extends "res://content/areas/Street.gd"

export (NodePath) var leaveHospitalAreaPath
export (Vector2) var leaveHospitalPlayerPosition

export (NodePath) var leaveMallAreaPath
export (Vector2) var leaveMallPlayerPosition

export (NodePath) var BusOverlayPath

func _ready():

	$LeaveHospitalTrigger.targetArea = get_node(leaveHospitalAreaPath)
	$LeaveHospitalTrigger.newPlayerPosition = leaveHospitalPlayerPosition

	$LeaveMallTrigger.targetArea = get_node(leaveMallAreaPath)
	$LeaveMallTrigger.newPlayerPosition = leaveMallPlayerPosition
	
	$BusTrigger.targetOverlay = get_node(BusOverlayPath)
	
	cars = {
		46: $car_46,
		47: $car_47
	}
