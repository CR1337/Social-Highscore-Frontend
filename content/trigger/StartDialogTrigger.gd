extends "res://content/trigger/Trigger.gd"

func trigger(kwargs):
	.trigger(kwargs)
	get_parent().start_dialog()
