extends "res://content/areas/Street.gd"


export (NodePath) var leavePoliceAreaPath
export (Vector2) var leavePolicePlayerPosition

func _ready():

	$LeavePoliceTriggerArea/LeavePoliceTrigger.targetArea = get_node(leavePoliceAreaPath)
	$LeavePoliceTriggerArea/LeavePoliceTrigger.newPlayerPosition = leavePolicePlayerPosition

	cars = {
		27: $car_27,
		31: $car_31,
		35: $car_35,
		40: $car_40
	}
