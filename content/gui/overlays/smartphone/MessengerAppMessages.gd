extends Node2D

var _messages = {
	'friend': [],
	'partner': [],
	'mom': [],
	'boss': []
}

onready var _name_label = $Background/Margin/VBox/NameLabel
onready var _messages_label = $Background/Margin/VBox/MessagesLabel

var _current_contact = 'mom'  # default value for creating default savegame

func persistent_state():
	return {
		'messages': _messages,
		'current_contact': _current_contact
	}

func restore_state(state):
	_messages = state['messages']
	set_current_contact(state['current_contact'])

func _ready():
	EventBus.connect("sig_got_phone_message", self, "_on_got_phone_message")

func _on_got_phone_message(contact, message):
	_messages[contact].append([false, message])

func set_current_contact(contact):
	_name_label.text = contact
	_current_contact = contact

	_display_messages()
	

func _display_messages():
	_messages_label.bbcode_text = ""
	for message_tuple in _messages[_current_contact]:
		if message_tuple[0]:
			_messages_label.append_bbcode("\n\n[color=green][right]" + message_tuple[1] + "[/right][/color]")
		else:
			_messages_label.append_bbcode("\n\n[color=white]" + message_tuple[1] + "[/color]")
	_messages_label.scroll_to_line(_messages_label.get_line_count()-1)



func _on_BackButton_pressed():
	ViewportManager.change_to_messenger_contacts()
	EventBus.emit_signal("sig_opened_message", _current_contact)
