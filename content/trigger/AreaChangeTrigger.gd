extends "res://content/trigger/Trigger.gd"

var target_area: Node2D
var new_player_position: Vector2

var blocked = false

export var blocked_dialog_filename: String

func trigger(kwargs):
	.trigger(kwargs)
	if kwargs.get('action') == 'block':
		blocked = true
		get_parent().walkable = false
		return
	if kwargs.get('action') == 'unblock':
		blocked = false
		get_parent().walkable = true
		return
	if not blocked:
		ViewportManager.change_area(target_area, new_player_position)
	else:
		ViewportManager.change_to_dialog(blocked_dialog_filename, "blocked")
