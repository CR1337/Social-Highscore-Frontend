extends "res://content/trigger/Trigger.gd"

func trigger(kwargs):
	.trigger(kwargs)
	get_parent().request_state_change('state0')
