extends "res://content/areas/Street.gd"

export (NodePath) var leaveBottomAreaPath
export (Vector2) var leaveBottomPlayerPosition

export (NodePath) var leaveLeftAreaPath
export (Vector2) var leaveLeftPlayerPosition

export (NodePath) var leaveTopAreaPath
export (Vector2) var leaveTopPlayerPosition

export (NodePath) var leavePoliceAreaPath
export (Vector2) var leavePolicePlayerPosition

func _ready():
	$LeaveBottomTrigger.targetArea = get_node(leaveBottomAreaPath)
	$LeaveBottomTrigger.newPlayerPosition = leaveBottomPlayerPosition
	
	$LeaveLeftTrigger.targetArea = get_node(leaveLeftAreaPath)
	$LeaveLeftTrigger.newPlayerPosition = leaveLeftPlayerPosition
	
	$LeaveTopTrigger.targetArea = get_node(leaveTopAreaPath)
	$LeaveTopTrigger.newPlayerPosition = leaveTopPlayerPosition

	$LeavePoliceTrigger.targetArea = get_node(leavePoliceAreaPath)
	$LeavePoliceTrigger.newPlayerPosition = leavePolicePlayerPosition

	cars = {
		27: $car_27,
		31: $car_31,
		35: $car_35,
		40: $car_40
	}
