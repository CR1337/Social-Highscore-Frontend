extends "res://content/areas/Street.gd"

export (NodePath) var bus_overlay_path

func _ready():

	$BusTriggerArea/BusTrigger.target_overlay = get_node(bus_overlay_path)
