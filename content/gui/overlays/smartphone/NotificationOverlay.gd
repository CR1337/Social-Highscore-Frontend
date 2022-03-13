extends Node2D

onready var _text_label = $Background/Margin/HBox/NotificationLabel
onready var _icon_texture = $Background/Margin/HBox/IconTexture
onready var _notification_sprite = $Background/NotificationSprite

export var news_icon: Texture
export var bank_icon: Texture
export var score_icon: Texture
export var message_icon: Texture
export var default_icon: Texture

var _notifications = {
	'news': null,
	'bank': null,
	'score': null,
	'message': null,
	'message_partner': null,
	'message_friend': null,
	'message_mom': null,
	'message_boss': null
}
var _current_notification = null

func persistent_state():
	return {
		'notifications': _notifications,
		'current_notification': _current_notification
	}
	
func restore_state(state):
	_notifications = state['notifications']
	_change_current_notification(state['current_notification'])

func _ready():
	EventBus.connect("sig_notification", self, '_on_notification')
	
func _hide():
	ViewportManager.change_to_transparent_notification()	
	
func _show():
	ViewportManager.change_to_notification()
	
func timer_elapsed(handle):
	if _current_notification == null:
		return
	if not _current_notification['important']:
		_show_next()
	
func _show_next():
	_notifications[_current_notification['type']] = null
	_change_current_notification(_next_notification())

func _next_notification():
	# return first important one
	for n in _notifications.values():
		if n == null:
			continue
		if n['important']:
			return n
	# return first found if there is no important one
	for n in _notifications.values():
		if n != null:
			return n
	# return null if there is no one
	return null
	
func _change_current_notification(new_notification):
	_current_notification = new_notification
	if new_notification == null:
		_hide()
	else:
		_text_label.text = new_notification['text']
		if new_notification['important']:
			_notification_sprite.animation = 'important'
		else:
			_notification_sprite.animation = 'default'
			TimeController.setTimer(10, self, "timer_elapsed")
		match new_notification['type']:
			'news':
				_icon_texture.texture = news_icon
			'bank':
				_icon_texture.texture = bank_icon
			'score':
				_icon_texture.texture = score_icon
			'message', 'message_partner', 'message_friend', 'message_mom', 'message_boss':
				_icon_texture.texture = message_icon
		_show()

func _on_notification(type, text, important = false):
	var new_notification = {
		'text': text,
		'important': important,
		'type': type
	}
	_notifications[type] = new_notification
	if _current_notification != null:
		if important or not _current_notification['important']:
			_change_current_notification(new_notification)
	else:
		_change_current_notification(new_notification)

func _on_Button_pressed():
	var type = _current_notification['type']
	match type:
		'news':
			ViewportManager.change_to_news_app_newspage(0)
		'bank':
			ViewportManager.change_to_banking_app()
		'score':
			ViewportManager.change_to_citizen_app()
		'message':
			ViewportManager.change_to_messenger_contacts()
		_:
			if type.begins_with('message'):
				var contact = type.split("_")[1]
				ViewportManager.change_to_messenger_messages(contact)

	_show_next()
