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
var _current_addressee: String

func _filename_to_addressee(filename):
	var _arr = filename.split("/")
	var _addressee = _arr[len(_arr)-1]
	_arr = _addressee.split(".")
	_addressee = _arr[0]
	_arr = _addressee.split("_")
	_current_addressee = _arr[len(_arr)-1]

func initialize(json_filename, state):
	GameStateController.pause_hunger_timer()
	_load_json(json_filename)
	_current_state = state
	_current_node_id = _dialog_dict['graphs'][_current_state]['initial_nid']
	_filename_to_addressee(json_filename)
	print("talking to " + _current_addressee)
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
	var text = _dialog_dict['texts'][text_id]
	_label.text = _format_text(text)
	_label.scroll_to_line(0)

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
		if trigger_id == "tid_critical_speech":
			var text_id = _current_node['answers'][answer_index]['tid']
			var body = {
				"addressee": _current_addressee,
				"place": ViewportManager.current_place_string(),
				"text": _dialog_dict['texts'][text_id]
			}
			EventBus.call_deferred("emit_signal", "sig_trigger", trigger_id, body)
		else:
			EventBus.call_deferred("emit_signal", "sig_trigger", trigger_id, _current_node['answers'][answer_index].get('trigger_kwargs', {}))

	var next_node_id = _current_node['answers'][answer_index]['nid']
	if next_node_id == null:
		GameStateController.continue_hunger_timer()
		ViewportManager.change_to_transparent_dialog()
	else:
		_current_node_id = next_node_id
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

# BEGIN system for dialog text formatting

# With this system we can now reference variables and functions
# of any autoloaded singleton inside dialog texts
# Use "...$$<singleton>.<variable_name>$$..." 
# or "...????<singleton>.<function_name>????..."
# eg: $$GameStateController.score$$ will evaluate to the current score
# ????GameStateController.remaining_shopping_capacity???? will evaluate
# to the current remaining space in the shopping cart

func _format_text(text):
	var variable_escape_sequence = "$$"
	var function_escape_sequence = "????"
	if text.find(variable_escape_sequence) >= 0:
		text = _format_text_replace(
			text, variable_escape_sequence, 
			"_get_replacement_variable"
		)
	if text.find(function_escape_sequence) >= 0:
		text = _format_text_replace(
			text, function_escape_sequence,
			"_get_replacement_function_value"
		)
	return text
	
func _format_text_replace(text, escape_sequence, replacement_func):
	var splits = text.split(escape_sequence)
	var start_index = 1
	if text.begins_with(escape_sequence):
		start_index = 0
	for i in range(start_index, len(splits), 2):
		var target = splits[i].split(".")
		splits[i] = str(call(replacement_func, target))
	var result = ""
	for s in splits:
		result += s
	return result

func _get_replacement_variable(target):
	var singleton = _get_singleton(target[0])
	return singleton.get(target[1])
	
func _get_replacement_function_value(target):
	var singleton = _get_singleton(target[0])
	return singleton.call(target[1])
	
func _get_singleton(singleton_name):
	return get_node("/root/" + singleton_name)

# END system for dialog text formatting
