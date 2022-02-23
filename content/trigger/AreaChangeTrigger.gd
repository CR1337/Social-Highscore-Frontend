extends "res://content/trigger/Trigger.gd"

var target_area: Node2D
var new_player_position: Vector2

func _on_trigger(trigger_id, kwargs):
	._on_trigger(trigger_id, kwargs)
	get_parent().walkable = not _blocked

func trigger(kwargs):
	.trigger(kwargs)
	if not _blocked:
		ViewportManager.change_area(target_area, new_player_position)
	else:
		ViewportManager.change_to_dialog(blocked_dialog_filename, _block_state)
