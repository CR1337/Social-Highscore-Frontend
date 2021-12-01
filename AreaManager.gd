extends Node

export (NodePath) var playerPath
export (NodePath) var startArea

var player: Area2D
var currentArea: Node2D

func _ready():
	EventBus.connect("area_change", self, "_on_area_change")
	player = get_node(playerPath)
	currentArea = get_node(startArea)
	
func _on_area_change(targetAreaPath, newPlayerPosition):
	var targetArea = get_node(targetAreaPath)
	var tmp_position = targetArea.position
	targetArea.position = currentArea.position
	currentArea.position = tmp_position
	currentArea = targetArea
	
	player.position = newPlayerPosition * player.get_tilesize()
