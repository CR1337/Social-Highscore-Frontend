extends Node2D

export var new_message_texture: Texture
export var no_message_texture: Texture

onready var partner_button = $Background/Margin/VBox/VBox/PartnerButton
onready var friend_button = $Background/Margin/VBox/VBox/FriendButton
onready var mom_button = $Background/Margin/VBox/VBox/MomButton
onready var boss_button = $Background/Margin/VBox/VBox/BossButton

var boss_in_contacts = false

func persistent_state():
	return {
		'boss_in_contacts': boss_in_contacts,
		'new_partner_message': (partner_button.icon == new_message_texture),
		'new_friend_message': (friend_button.icon == new_message_texture),
		'new_mom_message': (mom_button.icon == new_message_texture),
		'new_boss_message': (boss_button.icon == new_message_texture)
	}

func restore_state(state):
	boss_in_contacts = state['boss_in_contacts']
	if state['new_partner_message']:
		partner_button.icon = new_message_texture
	if state['new_friend_message']:
		friend_button.icon = new_message_texture
	if state['new_mom_message']:
		mom_button.icon = new_message_texture
	if state['new_boss_message']:
		boss_button.icon = new_message_texture
	if boss_in_contacts:
		boss_button.visible = true

func _ready():
	EventBus.connect("sig_got_phone_message", self, "_on_got_phone_message")
	boss_button.visible = false
	
	partner_button.icon = no_message_texture
	mom_button.icon = no_message_texture
	friend_button.icon = no_message_texture
	boss_button.icon = no_message_texture


func add_boss_to_contacts():
	boss_in_contacts = true
	boss_button.visible = true

func _on_got_phone_message(contact, message):
	match contact:
		'partner':
			partner_button.icon = new_message_texture
		'friend':
			friend_button.icon = new_message_texture
		'mom':
			mom_button.icon = new_message_texture
		'boss':
			boss_button.icon = new_message_texture
	var notification_text = "New message from " + contact
	EventBus.emit_signal("sig_notification", 'message', notification_text)

func _on_PartnerButton_pressed():
	partner_button.icon = no_message_texture
	ViewportManager.change_to_messenger_messages('partner')


func _on_MomButton_pressed():
	mom_button.icon = no_message_texture
	ViewportManager.change_to_messenger_messages('mom')


func _on_FriendButton_pressed():
	friend_button.icon = no_message_texture
	ViewportManager.change_to_messenger_messages('friend')


func _on_BossButton_pressed():
	boss_button.icon = no_message_texture
	ViewportManager.change_to_messenger_messages('boss')


func _on_BackButton_pressed():
	ViewportManager.change_to_smartphone()
