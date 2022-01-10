extends "res://content/areas/Street.gd"

export (NodePath) var leaveStoreAreaPath
export (Vector2) var leaveStorePlayerPosition

func _ready():

	$LeaveStoreTrigger.targetArea = get_node(leaveStoreAreaPath)
	$LeaveStoreTrigger.newPlayerPosition = leaveStorePlayerPosition

	cars = {
		28: $car_28,
		30: $car_30,
		36: $car_36,
		38: $car_38, 
		39: $car_39, 
		44: $car_44
	}
