extends "res://content/areas/Street.gd"

export (NodePath) var BusOverlayPath

func _ready():

	$BusTriggerArea/BusTrigger.targetOverlay = get_node(BusOverlayPath)
	
	cars = {
		0: $car_0,
		4: $car_4,
		5: $car_5,
		9: $car_9,
		10: $car_10,
		12: $car_12,
		13: $car_13,
		14: $car_14
	}

