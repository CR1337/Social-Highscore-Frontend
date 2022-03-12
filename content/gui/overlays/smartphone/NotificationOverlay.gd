extends Node2D

onready var _text_label = $Background/Margin/HBox/NotificationLabel
onready var _icon_texture = $Background/Margin/HBox/IconTexture
onready var _notification_sprite = $Background/NotificationSprite

export var news_icon: Texture
export var bank_icon: Texture
export var score_icon: Texture
export var message_icon: Texture
export var default_icon: Texture

var _current_type = "None"

var _important_notifications = []
var _notifications = []

func _ready():
	EventBus.connect("sig_notification", self, '_on_notification')

func _on_notification(type, text, important = false):
	if important:
		_important_notifications.append({
			'type': type,
			'text': text
		})
	else:
		_notifications.append({
			'type': type,
			'text': text
		})
	
	_current_type = type
	if not important:
		TimeController.setTimer(10, self, "hide_overlay")
		_notification_sprite.animation = 'default'
	else:
		_notification_sprite.animation = 'important'
	match type:
		'news':
			_icon_texture.texture = news_icon
		'bank':
			_icon_texture.texture = bank_icon
		'score':
			_icon_texture.texture = score_icon
		'message', 'message_partner', 'message_friend', 'message_mom', 'message_boss':
			_icon_texture.texture = message_icon
		_: # unknown type
			_icon_texture.texture = default_icon

	_text_label.text = text

	ViewportManager.change_to_notification()

func hide_overlay(handle):
	ViewportManager.change_to_transparent_notification()

func _on_Button_pressed():
	match _current_type:
		'news':
			ViewportManager.change_to_news_app_newspage(0)
		'bank':
			ViewportManager.change_to_banking_app()
		'score':
			ViewportManager.change_to_citizen_app()
		'message':
			ViewportManager.change_to_messenger_contacts()
		'message_partner':
			ViewportManager.change_to_messenger_messages('partner')
		'message_friend':
			ViewportManager.change_to_messenger_messages('friend')
		'message_mom':
			ViewportManager.change_to_messenger_messages('mom')
		'message_boss':
			ViewportManager.change_to_messenger_messages('boss')

	ViewportManager.change_to_transparent_notification()
	_current_type = 'None'
