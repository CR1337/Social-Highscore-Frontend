extends Node

var targetArea: NodePath
var newPlayerPosition: Vector2


func trigger():
	ViewportManager.change_area(targetArea, newPlayerPosition)
