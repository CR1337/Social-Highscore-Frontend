extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _current_payment_handle: String
var _current_amount = 0
var _current_recipient: String
var trigger_id = "tid_payment_overlay"

onready var _info_label = $Background/Margin/VBox/InfoLabel
onready var _error_label = $Background/Margin/VBox/ErrorLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("sig_trigger", self, "on_trigger")

func update_payment(recipient, amount, payment_handle):
	_info_label.visible = true
	_error_label.visible = false
	$Background/Margin/VBox/AmountLabel.text = str(amount)
	$Background/Margin/VBox/RecipientLabel.text = recipient
	_current_payment_handle = payment_handle
	_current_amount = amount
	_current_recipient = recipient
	
func _display_error(message):
	_info_label.visible = false
	_error_label.visible = true
	_error_label.bbcode_text = ""
	_error_label.append_bbcode("[color=red]" + message + "[/color]")
		
func on_trigger(tid, kwargs):
	if tid != trigger_id:
		return
	if GameStateController.bank_account_blocked:
		_display_error("Your bank account is blocked. Please consult your local bank.")
	elif kwargs.get('success') == true:
		EventBus.emit_signal("sig_payment_successfull", _current_payment_handle)
		EventBus.emit_signal("sig_add_money", -_current_amount, _current_recipient)
		ViewportManager.change_to_transparent()
	else:
		_display_error("Your face could not be authenticated. Please try again.")

func _on_OkButton_pressed():
	ViewportManager.change_to_authentication(trigger_id)


func _on_NotOkButton_pressed():
	EventBus.emit_signal("sig_payment_failed", _current_payment_handle)
	ViewportManager.change_to_transparent()
