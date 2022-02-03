extends "res://content/trigger/Trigger.gd"

var target_area: Node2D
var new_player_position: Vector2


func trigger():
	.trigger()
	ViewportManager.change_area(target_area, new_player_position)
