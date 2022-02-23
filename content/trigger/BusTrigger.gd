extends "res://content/trigger/Trigger.gd"

const _payment_handle = 'ph_bus'
const _recipient =  'Transportation services'
const _base_amount = 10

func _ready():
	EventBus.connect("sig_payment_failed", self, "_on_payment_failed")
	EventBus.connect("sig_payment_successfull", self, "_on_payment_successfull")
	
func payment_needed():
	return not GameStateController.ticket_bought

func _on_payment_failed(handle):
	if handle == _payment_handle:
		ViewportManager.change_to_dialog(
			"res://dialogs/other/bus_self_talk.json",
			"payment_failed"
		)
	
func _on_payment_successfull(handle):
	if handle == _payment_handle:
		GameStateController.ticket_bought = true
		ViewportManager.call_deferred("change_to_bus")

func trigger(kwargs):
	.trigger(kwargs)
	if _blocked:
		ViewportManager.change_to_dialog(
			blocked_dialog_filename,
			_block_state
		)
	elif payment_needed():
		ViewportManager.change_to_payment(_recipient, _base_amount * GameStateController.price_factor(), _payment_handle)
	else:
		ViewportManager.change_to_bus()
