extends "res://content/trigger/Trigger.gd"


const _payment_handle = 'ph_gym'
const _recipient =  'Superfit'

func _ready():
	EventBus.connect("sig_payment_failed", self, "_on_payment_failed")
	EventBus.connect("sig_payment_successfull", self, "_on_payment_successfull")

func _on_payment_failed(handle):
	if handle == _payment_handle:
		GameStateController.gym_payment_failed()

func _on_payment_successfull(handle):
	if handle == _payment_handle:
		GameStateController.gym_payment_successful()

func trigger(kwargs):
	var amount = GameStateController.gym_price()
	ViewportManager.change_to_payment(_recipient, amount, _payment_handle)
