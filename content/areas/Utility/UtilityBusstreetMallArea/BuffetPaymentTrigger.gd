extends "res://content/trigger/Trigger.gd"

const _payment_handle = 'ph_mall_buffet_'
const _recipient =  'Buffet'


func _ready():
	EventBus.connect("sig_payment_failed", self, "_on_payment_failed")
	EventBus.connect("sig_payment_successfull", self, "_on_payment_successfull")

func _on_payment_failed(handle):
	if handle != _payment_handle + _item_key():
		return

func _item_key():
	return id.trim_prefix("tid_mall_buffet_")

func _on_payment_successfull(handle):
	if handle != _payment_handle + _item_key():
		return
	GameStateController.eat_mall_food(_item_key())

func trigger(kwargs):
	var amount = GameStateController.get_buffet_item_price(_item_key())
	ViewportManager.change_to_payment(_recipient, amount, _payment_handle + _item_key())
	
