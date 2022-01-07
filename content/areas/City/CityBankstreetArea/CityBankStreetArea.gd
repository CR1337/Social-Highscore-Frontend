extends "res://content/areas/Street.gd"

export (NodePath) var leaveRightAreaPath
export (Vector2) var leaveRightPlayerPosition

export (NodePath) var leaveTopAreaPath
export (Vector2) var leaveTopPlayerPosition

export (NodePath) var leaveOfficeAreaPath
export (Vector2) var leaveOfficePlayerPosition

export (NodePath) var leaveBankAreaPath
export (Vector2) var leaveBankPlayerPosition

func _ready():

	$LeaveRightTrigger.targetArea = get_node(leaveRightAreaPath)
	$LeaveRightTrigger.newPlayerPosition = leaveRightPlayerPosition
	
	$LeaveTopTrigger.targetArea = get_node(leaveTopAreaPath)
	$LeaveTopTrigger.newPlayerPosition = leaveTopPlayerPosition
	
	$LeaveOfficeTrigger.targetArea = get_node(leaveOfficeAreaPath)
	$LeaveOfficeTrigger.newPlayerPosition = leaveOfficePlayerPosition
	
	$LeaveBankTrigger.targetArea = get_node(leaveBankAreaPath)
	$LeaveBankTrigger.newPlayerPosition = leaveBankPlayerPosition

	cars = {
		29: $car_29,
		37: $car_37,
		45: $car_45
	}
