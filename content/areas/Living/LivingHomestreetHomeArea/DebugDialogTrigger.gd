extends "res://content/Trigger.gd"

func trigger():
	.trigger()
	ViewportManager.change_to_dialog("res://doc/dialog.json", "state0")
