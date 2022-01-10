extends "res://content/areas/Street.gd"

export (NodePath) var leaveOfficeAreaPath
export (Vector2) var leaveOfficePlayerPosition

export (NodePath) var leaveBankAreaPath
export (Vector2) var leaveBankPlayerPosition

func _ready():

	$LeaveOfficeTrigger.targetArea = get_node(leaveOfficeAreaPath)
	$LeaveOfficeTrigger.newPlayerPosition = leaveOfficePlayerPosition
	
	$LeaveBankTrigger.targetArea = get_node(leaveBankAreaPath)
	$LeaveBankTrigger.newPlayerPosition = leaveBankPlayerPosition

	cars = {
		29: $car_29,
		37: $car_37,
		45: $car_45
	}
