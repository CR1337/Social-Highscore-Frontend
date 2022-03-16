extends "res://content/trigger/Trigger.gd"

var _previous_state = 'idle'

const _class_states = [
	"class AAA",
	"class AA",
	"class A",
	"class B",
	"class C",
	"class D",
	"class E",
	"class X"
]

func trigger(kwargs):
	.trigger(kwargs)
	var _current_state = get_parent().state
	if _current_state != _class_states[GameStateController.score_class()]:
		_previous_state = _current_state
		get_parent().request_state_change(_class_states[GameStateController.score_class()])
		get_parent().call_deferred("start_dialog")
	else:
		get_parent().request_state_change(_previous_state)
