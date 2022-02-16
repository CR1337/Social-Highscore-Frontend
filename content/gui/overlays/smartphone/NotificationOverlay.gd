extends Node2D

onready var _text_label = $Background/Margin/HBox/NotificationLabel
onready var _icon_texture = $Background/Margin/HBox/IconTexture

export var news_icon: Texture
export var bank_icon: Texture
export var score_icon: Texture
export var message_icon: Texture
export var default_icon: Texture

var _current_type = "None"

var _hide_overlay_handle = -1

func _ready():
	EventBus.connect("sig_notification", self, '_on_notification')

func _on_notification(type, text):
	_current_type = type
	_hide_overlay_handle = TimeController.setTimer(10, self, "timer")
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

func timer(handle):
	if _hide_overlay_handle == handle:
		_hide_overlay_handle = -1
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
