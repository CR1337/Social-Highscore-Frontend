extends Node2D

onready var _label = $Background/Margin/VBox/TextLabel
onready var _buttons = [
	$Background/Margin/VBox/Answer0Button,
	$Background/Margin/VBox/Answer1Button,
	$Background/Margin/VBox/Answer2Button,
	$Background/Margin/VBox/Answer3Button,
]

var _dialog_dict = {}
var _current_state: String
var _current_node_id: String
var _current_node = {}

func initialize(json_filename, state):
	_load_json(json_filename)
	_current_state = state
	_current_node_id = _dialog_dict['graphs'][_current_state]['initial_nid']
	_display()

func _load_json(filename):
	var file = File.new()
	file.open(filename, file.READ)
	_dialog_dict = JSON.parse(
		file.get_as_text()
	).result
	file.close()

func _display_current():
	_current_node = _dialog_dict['graphs'][_current_state][_current_node_id]
	_arrange_buttons(len(_current_node['answers']))

	var text_id = _current_node['tid']
	_label.text = _dialog_dict['texts'][text_id]

	for i in len(_current_node['answers']):
		text_id = _current_node['answers'][i]['tid']
		_buttons[i].text = _dialog_dict['texts'][text_id]

func _display():
	_display_current()
	var trigger_id = _current_node['trigger_id']
	if trigger_id != null:
		EventBus.emit_signal("sig_trigger", trigger_id, _current_node.get('trigger_kwargs', {}))

func _arrange_buttons(answer_count):
	_label.rect_min_size.y = 104
	for i in 4:
		_buttons[i].visible = true
	if answer_count < 4:
		_label.rect_min_size.y = 160
		_buttons[3].visible = false
	if answer_count < 3:
		_label.rect_min_size.y = 216
		_buttons[2].visible = false
	if answer_count < 2:
		_label.rect_min_size.y = 272
		_buttons[1].visible = false

func _process_answer(answer_index):
	var trigger_id = _current_node['answers'][answer_index]['trigger_id']
	if trigger_id != null:
		EventBus.call_deferred("emit_signal", "sig_trigger", trigger_id, _current_node['answers'][answer_index].get('trigger_kwargs', {}))
		# yield(EventBus, "sig_dialog_trigger_completed")

	var next_node_id = _current_node['answers'][answer_index]['nid']
	if next_node_id == null:
		ViewportManager.change_to_transparent()
	else:
		_current_node_id = next_node_id
		trigger_id = _current_node['answers'][answer_index]['trigger_id']
		if trigger_id != null:
			EventBus.call_deferred("emit_signal", "sig_trigger", trigger_id, _current_node['answers'][answer_index].get('trigger_kwargs', {}))
			# yield(EventBus, "sig_dialog_trigger_completed")
		_display()


func _on_Answer3Button_pressed():
	_process_answer(3)


func _on_Answer2Button_pressed():
	_process_answer(2)


func _on_Answer1Button_pressed():
	_process_answer(1)


func _on_Answer0Button_pressed():
	_process_answer(0)

func persistent_state():
	return {
		"dialog_dict": _dialog_dict,
		"current_state": _current_state,
		"current_node_id": _current_node_id,
		"current_node": _current_node
	}

func restore_state(state):
	_dialog_dict = state['dialog_dict']
	_current_state = state['current_state']
	_current_node_id = state['current_node_id']
	_current_node = state['current_node']
	if not _dialog_dict.empty():
		_display_current()
