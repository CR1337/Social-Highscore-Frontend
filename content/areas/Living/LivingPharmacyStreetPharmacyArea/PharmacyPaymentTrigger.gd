extends "res://content/trigger/Trigger.gd"


const _payment_handle = 'ph_pharmacy'
const _recipient =  'Pharmacy'
const _base_amount = 50

func _ready():
	EventBus.connect("sig_payment_failed", self, "_on_payment_failed")
	EventBus.connect("sig_payment_successfull", self, "_on_payment_successfull")

func _on_payment_failed(handle):
	if handle == _payment_handle:
		get_parent().request_state_change('payment_failed')
		get_parent().call_deferred("start_dialog")

func _on_payment_successfull(handle):
	if handle == _payment_handle:
		get_parent().request_state_change('payment_accepted')
		get_parent().call_deferred("start_dialog")

func trigger(kwargs):
	var amount = _base_amount * GameStateController.price_factor
	ViewportManager.change_to_payment(_recipient, amount, _payment_handle)
