extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _current_payment_handle: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_payment(recipient, amount, payment_handle):
	$Background/Margin/VBox/AmountLabel.text = str(amount)
	$Background/Margin/VBox/RecipientLabel.text = recipient
	_current_payment_handle = payment_handle


func _on_OkButton_pressed():
	EventBus.emit_signal("sig_payment_successfull", _current_payment_handle)
	ViewportManager.change_to_transparent()


func _on_NotOkButton_pressed():
	EventBus.emit_signal("sig_payment_failed", _current_payment_handle)
	ViewportManager.change_to_transparent()
