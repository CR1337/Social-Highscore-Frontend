extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _current_payment_handle: String
var trigger_id = "tid_payment_overlay"

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("sig_trigger", self, "on_trigger")

func update_payment(recipient, amount, payment_handle):
	$Background/Margin/VBox/AmountLabel.text = str(amount)
	$Background/Margin/VBox/RecipientLabel.text = recipient
	_current_payment_handle = payment_handle


func on_trigger(tid, kwargs):
	if tid != trigger_id:
		return
	if kwargs.get('success') == true:
		EventBus.emit_signal("sig_payment_successfull", _current_payment_handle)
		ViewportManager.change_to_transparent()
	else:
		EventBus.emit_signal("sig_payment_failed", _current_payment_handle)
		ViewportManager.change_to_transparent()

func _on_OkButton_pressed():
	ViewportManager.change_to_authentication(trigger_id)


func _on_NotOkButton_pressed():
	EventBus.emit_signal("sig_payment_failed", _current_payment_handle)
	ViewportManager.change_to_transparent()
