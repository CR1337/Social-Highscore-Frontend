extends "res://content/areas/Street.gd"

export (NodePath) var BusOverlayPath

func _ready():

	$BusTriggerArea/BusTrigger.targetOverlay = get_node(BusOverlayPath)
