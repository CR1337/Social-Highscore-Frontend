extends "res://content/trigger/Trigger.gd"

func trigger():
	.trigger()
	get_parent().request_state_change('state0')

func _ready():
	trigger()
