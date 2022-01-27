extends Node2D

onready var text_label = $Background/MarginContainer/HBoxContainer/NotificationLabel
onready var icon_texture = $Background/MarginContainer/HBoxContainer/IconTexture

export var news_icon: Texture
export var bank_icon: Texture
export var score_icon: Texture
export var message_icon: Texture
export var default_icon: Texture

var current_type = "None"

var hide_overlay_handler = -1

func _ready():
	EventBus.connect("sig_notification", self, '_on_notification')

func _on_notification(type, text):
	current_type = type
	hide_overlay_handler = TimeController.setTimer(10, self)
	match type:
		'news':
			icon_texture.texture = news_icon
		'bank':
			icon_texture.texture = bank_icon
		'score':
			icon_texture.texture = score_icon
		'message':
			icon_texture.texture = message_icon
		_: # unknown type
			icon_texture.texture = default_icon
	
	text_label.text = text
	
	ViewportManager.change_to_notification()

func timer(handle):
	if hide_overlay_handler == handle:
		hide_overlay_handler = -1
		ViewportManager.change_to_transparent_notification()

func _on_Button_pressed():
	match current_type:
		'news':
			ViewportManager.change_to_news_app_newspage(0)
		'bank':
			ViewportManager.change_to_banking_app()
		'score':
			ViewportManager.change_to_citizen_app()
		'message':
			ViewportManager.change_to_messenger_contacts()
		
	ViewportManager.change_to_transparent_notification()
	current_type = 'None'
