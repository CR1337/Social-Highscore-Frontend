extends Node2D

export var new_message_texture: Texture
export var no_message_texture: Texture

onready var _partner_button = $Background/Margin/VBox/VBox/PartnerButton
onready var _friend_button = $Background/Margin/VBox/VBox/FriendButton
onready var _mom_button = $Background/Margin/VBox/VBox/MomButton
onready var _boss_button = $Background/Margin/VBox/VBox/BossButton

var _boss_in_contacts = false

func persistent_state():
	return {
		'boss_in_contacts': _boss_in_contacts,
		'new_partner_message': (_partner_button.icon == new_message_texture),
		'new_friend_message': (_friend_button.icon == new_message_texture),
		'new_mom_message': (_mom_button.icon == new_message_texture),
		'new_boss_message': (_boss_button.icon == new_message_texture)
	}

func restore_state(state):
	_boss_in_contacts = state['boss_in_contacts']
	if state['new_partner_message']:
		_partner_button.icon = new_message_texture
	if state['new_friend_message']:
		_friend_button.icon = new_message_texture
	if state['new_mom_message']:
		_mom_button.icon = new_message_texture
	if state['new_boss_message']:
		_boss_button.icon = new_message_texture
	if _boss_in_contacts:
		_boss_button.visible = true

func _ready():
	EventBus.connect("sig_got_phone_message", self, "_on_got_phone_message")
	_boss_button.visible = false

	_partner_button.icon = no_message_texture
	_mom_button.icon = no_message_texture
	_friend_button.icon = no_message_texture
	_boss_button.icon = no_message_texture


func add_boss_to_contacts():
	_boss_in_contacts = true
	_boss_button.visible = true

func _on_got_phone_message(contact, message, important = false):
	match contact:
		'partner':
			_partner_button.icon = new_message_texture
		'friend':
			_friend_button.icon = new_message_texture
		'mom':
			_mom_button.icon = new_message_texture
		'boss':
			_boss_button.icon = new_message_texture
	var notification_text = "New message from " + contact
	EventBus.emit_signal("sig_notification", 'message_' + contact, notification_text, important)

func _on_PartnerButton_pressed():
	_partner_button.icon = no_message_texture
	ViewportManager.change_to_messenger_messages('partner')


func _on_MomButton_pressed():
	_mom_button.icon = no_message_texture
	ViewportManager.change_to_messenger_messages('mom')


func _on_FriendButton_pressed():
	_friend_button.icon = no_message_texture
	ViewportManager.change_to_messenger_messages('friend')


func _on_BossButton_pressed():
	_boss_button.icon = no_message_texture
	ViewportManager.change_to_messenger_messages('boss')


func _on_BackButton_pressed():
	ViewportManager.change_to_smartphone()
