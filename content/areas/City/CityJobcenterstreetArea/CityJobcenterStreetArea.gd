extends "res://content/areas/Street.gd"

export (NodePath) var leaveBottomAreaPath
export (Vector2) var leaveBottomPlayerPosition

export (NodePath) var leaveLeftAreaPath
export (Vector2) var leaveLeftPlayerPosition

export (NodePath) var leaveJobcenterAreaPath
export (Vector2) var leaveJobcenterPlayerPosition


func _ready():
	$LeaveBottomTrigger.targetArea = get_node(leaveBottomAreaPath)
	$LeaveBottomTrigger.newPlayerPosition = leaveBottomPlayerPosition
	
	$LeaveLeftTrigger.targetArea = get_node(leaveLeftAreaPath)
	$LeaveLeftTrigger.newPlayerPosition = leaveLeftPlayerPosition
	
	$LeaveJobcenterTrigger.targetArea = get_node(leaveJobcenterAreaPath)
	$LeaveJobcenterTrigger.newPlayerPosition = leaveJobcenterPlayerPosition
	
	cars = {
		16: $car_16,
		18: $car_18, 
		20: $car_20,
		24: $car_24,
		26: $car_26,
		32: $car_32,
		34: $car_34, 
		41: $car_41, 
		43: $car_43
		
	}
