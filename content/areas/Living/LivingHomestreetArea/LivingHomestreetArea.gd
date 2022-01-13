extends "res://content/areas/Street.gd"

export (NodePath) var leaveHomeAreaPath
export (Vector2) var leaveHomePlayerPosition

export (NodePath) var leaveMomAreaPath
export (Vector2) var leaveMomPlayerPosition

func _ready():

	$LeaveHomeTrigger.targetArea = get_node(leaveHomeAreaPath)
	$LeaveHomeTrigger.newPlayerPosition = leaveHomePlayerPosition	
	
	$LeaveMomTrigger.targetArea = get_node(leaveMomAreaPath)
	$LeaveMomTrigger.newPlayerPosition = leaveMomPlayerPosition
	
	cars = {
		1: $car_1,
		3: $car_3, 
		6: $car_6,
		8: $car_8,
		11: $car_11
	}
