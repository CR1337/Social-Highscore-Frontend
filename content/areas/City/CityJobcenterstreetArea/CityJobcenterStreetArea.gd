extends "res://content/areas/Street.gd"

export (NodePath) var leaveJobcenterAreaPath
export (Vector2) var leaveJobcenterPlayerPosition


func _ready():

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
