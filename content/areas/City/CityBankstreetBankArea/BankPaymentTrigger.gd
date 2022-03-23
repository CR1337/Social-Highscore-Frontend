extends "res://content/trigger/Trigger.gd"

const _payment_handle = 'ph_bank'
const _recipient =  'UNLOCK ACCOUNT'

func _ready():
	EventBus.connect("sig_payment_failed", self, "_on_payment_failed")
	EventBus.connect("sig_payment_successfull", self, "_on_payment_successfull")

func _on_payment_failed(handle):
	if handle != _payment_handle:
		return
	get_parent().request_state_change('day05_authentication_failed')
	get_parent().call_deferred("start_dialog")

func _on_payment_successfull(handle):
	if handle != _payment_handle:
		return
	get_parent().request_state_change('day05_authentication_accepted')
	get_parent().call_deferred("start_dialog")

func trigger(kwargs):
	ViewportManager.change_to_payment(_recipient, 0, _payment_handle)
