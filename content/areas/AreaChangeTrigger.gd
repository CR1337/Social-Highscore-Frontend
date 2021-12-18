extends Node

var targetArea: Node2D
var newPlayerPosition: Vector2


func trigger():
	ViewportManager.change_area(targetArea, newPlayerPosition)
