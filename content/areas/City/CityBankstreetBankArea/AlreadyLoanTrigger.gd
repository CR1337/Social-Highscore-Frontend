extends "res://content/trigger/Trigger.gd"

var _previous_state = 'idle'

func trigger(kwargs):
	.trigger(kwargs)
	var _current_state = get_parent().state
	if _current_state != "has_already_loan":
		_previous_state = _current_state
		get_parent().request_state_change('has_already_loan')
		get_parent().call_deferred("start_dialog")
	else:
		get_parent().request_state_change(_previous_state)
