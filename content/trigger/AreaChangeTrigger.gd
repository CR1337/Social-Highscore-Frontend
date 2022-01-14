extends "res://content/trigger/Trigger.gd"

var targetArea: Node2D
var newPlayerPosition: Vector2


func trigger():
	.trigger()
	ViewportManager.change_area(targetArea, newPlayerPosition)
