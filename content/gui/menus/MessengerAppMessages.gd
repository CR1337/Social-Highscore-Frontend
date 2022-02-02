extends Node2D

var _messages = {
	'friend': [],
	'partner': [],
	'mom': [],
	'boss': []
}
var _filenames = {
	'friend': "res://doc/messenger_friend.json", # Todo
	'mom': "res://doc/messenger_mom.json", # Todo
	'partner': "res://doc/messenger_partner.json", # Todo
	'boss': "res://doc/messenger_boss.json" # Todo
}

var current_node_ids = {
	'friend': "",
	'partner': "",
	'mom': "",
	'boss': ""
}

onready var name_label = $Background/Margin/VBox/NameLabel
onready var messages_label = $Background/Margin/VBox/MessagesLabel
onready var message_button = $Background/Margin/VBox/HBox/MessageButton
onready var send_button = $Background/Margin/VBox/HBox/SendButton
onready var margin_container = $Background/Margin

var current_contact: String
var dialog_dicts = {
	'friend': {},
	'partner': {},
	'mom': {}, 
	'boss': {}
}

var response_timer_handle: int
var _selected_answer_id = -1

func persistent_state():
	return {
		'messages': _messages,
		'current_node_ids': current_node_ids,
		'current_contact': current_contact,
		'response_timer_handle': response_timer_handle,
		'hidden': not margin_container.visible
	}
	
func restore_state(state):
	_messages = state['messages']
	current_node_ids = state['current_node_ids']
	response_timer_handle = state['response_timer_handle']
	if not state['hidden']:
		set_current_contact(state['current_contact'])
		show()

func _current_node():
	return _dialog_node(current_contact)

func _dialog_node(contact):
	return dialog_dicts[contact]['graphs'][GameStateController.contact_state[contact]][current_node_ids[contact]]

func _ready():
	EventBus.connect("sig_got_phone_message", self, "_on_got_phone_message")
	_hide()
	for contact in dialog_dicts.keys():
		var file = File.new()
		file.open(_filenames[contact], File.READ)

		dialog_dicts[contact] = JSON.parse(
			file.get_as_text()
		).result
		file.close()
		current_node_ids[contact] = dialog_dicts[contact]['graphs'][GameStateController.contact_state[contact]]['initial_nid']
		
		var text_id = _dialog_node(contact)['tid']
		_messages[contact].append([false, dialog_dicts[contact]['texts'][text_id]])


func _on_got_phone_message(contact, message):
	_messages[contact].append([false, message])
	
func show():
	margin_container.visible = true
	
func _hide():
	margin_container.visible = false

func update_answers():
	message_button.clear()
	print(len(_current_node()['answers']))
	for i in len(_current_node()['answers']):
		message_button.add_item(dialog_dicts[current_contact]['texts'][_current_node()['answers'][i]['tid']])
	send_button.disabled = false
	
func set_current_contact(contact):
	name_label.text = contact
	current_contact = contact

	_display_messages()
	update_answers()

func _display_messages():
	messages_label.bbcode_text = ""
	for message_tuple in _messages[current_contact]:
		if message_tuple[0]:
			messages_label.append_bbcode("\n\n[color=green][right]" + message_tuple[1] + "[/right][/color]")
		else:
			messages_label.append_bbcode("\n\n[color=white]" + message_tuple[1] + "[/color]")
	messages_label.scroll_to_line(messages_label.get_line_count()-1)
	


func _on_BackButton_pressed():
	ViewportManager.change_to_messenger_contacts()
	_hide()
	_selected_answer_id = -1


func _on_SendButton_pressed():
	var index = message_button.selected
	_process_answer(index)
	
func _process_answer(answer_index):
	var trigger_id = _current_node()['answers'][answer_index]['trigger_id']
	if trigger_id != null:
		EventBus.call_deferred("emit_signal", "trigger", trigger_id)
		yield(EventBus, "sig_dialog_trigger_completed") # wait until the trigger has completed
	_messages[current_contact].append([true, dialog_dicts[current_contact]['texts'][_current_node()['answers'][answer_index]['tid']]])
	current_node_ids[current_contact] = _current_node()['answers'][answer_index]['nid']
	
	trigger_id = _current_node()['trigger_id']
	if trigger_id != null:
		EventBus.call_deferred("emit_signal", "trigger", trigger_id)
		yield(EventBus, "sig_dialog_trigger_completed") # wait until the trigger has completed

	_display_messages()
	
	message_button.clear()
	send_button.disabled = true
	_selected_answer_id = -1
	response_timer_handle = TimeController.setTimer(1, self)
	
func timer(handle):
	if response_timer_handle == handle:
		var text_id = _current_node()['tid']
		_messages[current_contact].append([false, dialog_dicts[current_contact]['texts'][text_id]])
		_display_messages()
		update_answers()
