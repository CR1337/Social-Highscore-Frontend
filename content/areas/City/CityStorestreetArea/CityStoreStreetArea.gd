extends "res://content/areas/Street.gd"

export (NodePath) var leaveLeftAreaPath
export (Vector2) var leaveLeftPlayerPosition

export (NodePath) var leaveTopAreaPath
export (Vector2) var leaveTopPlayerPosition

func _ready():
	
	$LeaveLeftTrigger.targetArea = get_node(leaveLeftAreaPath)
	$LeaveLeftTrigger.newPlayerPosition = leaveLeftPlayerPosition
	
	$LeaveTopTrigger.targetArea = get_node(leaveTopAreaPath)
	$LeaveTopTrigger.newPlayerPosition = leaveTopPlayerPosition

	cars = {
		28: $car_28,
		30: $car_30,
		36: $car_36,
		38: $car_38, 
		39: $car_39, 
		44: $car_44
	}
	start_car(30)
	start_car(44)
