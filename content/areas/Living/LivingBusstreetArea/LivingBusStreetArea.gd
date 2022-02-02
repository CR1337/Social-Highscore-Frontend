extends "res://content/areas/Street.gd"

export (NodePath) var bus_overlay_path

func _ready():

	$BusTriggerArea/BusTrigger.targetOverlay = get_node(bus_overlay_path)
