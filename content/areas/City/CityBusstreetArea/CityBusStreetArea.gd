extends "res://content/areas/Street.gd"

export (NodePath) var leaveBottomAreaPath
export (Vector2) var leaveBottomPlayerPosition

export (NodePath) var leaveRightAreaPath
export (Vector2) var leaveRightPlayerPosition

export (NodePath) var BusOverlayPath


func _ready():
	$LeaveBottomTrigger.targetArea = get_node(leaveBottomAreaPath)
	$LeaveBottomTrigger.newPlayerPosition = leaveBottomPlayerPosition
	
	$LeaveRightTrigger.targetArea = get_node(leaveRightAreaPath)
	$LeaveRightTrigger.newPlayerPosition = leaveRightPlayerPosition
	
	$BusTrigger.targetOverlay = get_node(BusOverlayPath)
	
	cars = {
		15: $car_15,
		17: $car_17,
		19: $car_19,
		21: $car_21,
		23: $car_23,
		25: $car_25,
		33: $car_33, 
		42: $car_42
	}
	start_car(15)
	start_car(17)
	start_car(19)
