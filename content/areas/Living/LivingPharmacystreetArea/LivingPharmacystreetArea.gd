extends "res://content/areas/Street.gd"

export (NodePath) var leaveRightAreaPath
export (Vector2) var leaveRightPlayerPosition

export (NodePath) var leavePharmacyAreaPath
export (Vector2) var leavePharmacyPlayerPosition

func _ready():
	$LeaveRightTrigger.targetArea = get_node(leaveRightAreaPath)
	$LeaveRightTrigger.newPlayerPosition = leaveRightPlayerPosition

	$LeavePharmacyTrigger.targetArea = get_node(leavePharmacyAreaPath)
	$LeavePharmacyTrigger.newPlayerPosition = leavePharmacyPlayerPosition

	cars = {
		7: $car_7
	}
