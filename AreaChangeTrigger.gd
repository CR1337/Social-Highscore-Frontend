extends Node

var targetArea: NodePath
var newPlayerPosition: Vector2


func trigger():
	EventBus.emit_signal("area_change", targetArea, newPlayerPosition)
