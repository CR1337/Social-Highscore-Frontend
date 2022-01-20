extends "res://content/areas/Street.gd"

export (NodePath) var BusOverlayPath


func _ready():

	$BusTriggerArea/BusTrigger.targetOverlay = get_node(BusOverlayPath)
	
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
