extends "res://content/trigger/Trigger.gd"


func trigger(kwargs):
	.trigger(kwargs)
	ViewportManager.change_to_fridge()
