extends "res://content/areas/Street.gd"

export (NodePath) var leavePharmacyAreaPath
export (Vector2) var leavePharmacyPlayerPosition

func _ready():

	$LeavePharmacyTriggerArea/LeavePharmacyTrigger.targetArea = get_node(leavePharmacyAreaPath)
	$LeavePharmacyTriggerArea/LeavePharmacyTrigger.newPlayerPosition = leavePharmacyPlayerPosition

	cars = {
		7: $car_7
	}
