extends Node2D

var _messages = {
	'friend': [],
	'partner': [],
	'mom': [],
	'boss': []
}
var _filenames = {
	'friend': "res://dialogs/messenger/friend.json", # Todo
	'mom': "res://dialogs/messenger/mom.json", # Todo
	'partner': "res://dialogs/messenger/partner.json", # Todo
	'boss': "res://dialogs/messenger/boss.json" # Todo
}

var _current_node_ids = {
	'friend': "",
	'partner': "",
	'mom': "",
	'boss': ""
}

onready var _name_label = $Background/Margin/VBox/NameLabel
onready var _messages_label = $Background/Margin/VBox/MessagesLabel
onready var _message_button = $Background/Margin/VBox/HBox/MessageButton
onready var _send_button = $Background/Margin/VBox/HBox/SendButton
onready var _margin_container = $Background/Margin

var _current_contact: String
var _dialog_dicts = {
	'friend': {},
	'partner': {},
	'mom': {},
	'boss': {}
}

var _response_timer_handle: int
var _selected_answer_id = -1

func persistent_state():
	return {
		'messages': _messages,
		'current_node_ids': _current_node_ids,
		'current_contact': _current_contact,
		'response_timer_handle': _response_timer_handle,
		'hidden': not _margin_container.visible
	}

func restore_state(state):
	_messages = state['messages']
	_current_node_ids = state['current_node_ids']
	_response_timer_handle = state['response_timer_handle']
	if not state['hidden']:
		set_current_contact(state['current_contact'])
		show()

func _current_node():
	return _dialog_node(_current_contact)

func _dialog_node(contact):
	return _dialog_dicts[contact]['graphs'][GameStateController.contact_state[contact]][_current_node_ids[contact]]

func _ready():
	EventBus.connect("sig_got_phone_message", self, "_on_got_phone_message")
	_hide()
	for contact in _dialog_dicts.keys():
		var file = File.new()
		file.open(_filenames[contact], File.READ)

		_dialog_dicts[contact] = JSON.parse(
			file.get_as_text()
		).result
		file.close()
		_current_node_ids[contact] = _dialog_dicts[contact]['graphs'][GameStateController.contact_state[contact]]['initial_nid']

		var text_id = _dialog_node(contact)['tid']
		_messages[contact].append([false, _dialog_dicts[contact]['texts'][text_id]])


func _on_got_phone_message(contact, message):
	_messages[contact].append([false, message])

func show():
	_margin_container.visible = true

func _hide():
	_margin_container.visible = false

func _update_answers():
	_message_button.clear()
	for i in len(_current_node()['answers']):
		_message_button.add_item(_dialog_dicts[_current_contact]['texts'][_current_node()['answers'][i]['tid']])
	_send_button.disabled = false

func set_current_contact(contact):
	_name_label.text = contact
	_current_contact = contact

	_display_messages()
	_update_answers()
	
	EventBus.emit_signal("sig_opened_message", contact)

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
	_hide()
	_selected_answer_id = -1


func _on_SendButton_pressed():
	var index = _message_button.selected
	_process_answer(index)

func _process_answer(answer_index):
	var trigger_id = _current_node()['answers'][answer_index]['trigger_id']
	if trigger_id != null:
		EventBus.call_deferred("emit_signal", "sig_trigger", trigger_id)
		yield(EventBus, "sig_dialog_trigger_completed") # wait until the trigger has completed
	_messages[_current_contact].append([true, _dialog_dicts[_current_contact]['texts'][_current_node()['answers'][answer_index]['tid']]])
	_current_node_ids[_current_contact] = _current_node()['answers'][answer_index]['nid']

	trigger_id = _current_node()['trigger_id']
	if trigger_id != null:
		EventBus.call_deferred("emit_signal", "sig_trigger", trigger_id)
		yield(EventBus, "sig_dialog_trigger_completed") # wait until the trigger has completed

	_display_messages()

	_message_button.clear()
	_send_button.disabled = true
	_selected_answer_id = -1
	_response_timer_handle = TimeController.setTimer(1, self, "timer")

func timer(handle):
	if _response_timer_handle == handle:
		var text_id = _current_node()['tid']
		_messages[_current_contact].append([false, _dialog_dicts[_current_contact]['texts'][text_id]])
		_display_messages()
		_update_answers()
