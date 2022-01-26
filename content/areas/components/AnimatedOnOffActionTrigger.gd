extends "res://content/trigger/Trigger.gd"

func trigger():
	.trigger()
	get_parent().trigger()
