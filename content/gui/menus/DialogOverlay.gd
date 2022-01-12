extends Node2D

onready var label = $Background/MarginContainer/VBoxContainer/TextLabel
onready var buttons = [
	$Background/MarginContainer/VBoxContainer/LowerHBoxContainer/Answer0Button,
	$Background/MarginContainer/VBoxContainer/LowerHBoxContainer/Answer1Button,
	$Background/MarginContainer/VBoxContainer/UpperHBoxContainer/Answer2Button,
	$Background/MarginContainer/VBoxContainer/UpperHBoxContainer/Answer3Button,
]
onready var upper_h_box = $Background/MarginContainer/VBoxContainer/UpperHBoxContainer
#
var dialog_dict = {}
var current_state: String
var current_node_id: String
var current_node = {}

func initialize(json_filename, state):
	_load_json(json_filename)
	current_state = state
	current_node_id = dialog_dict['graphs'][current_state]['initial_nid']
	_display()

func _load_json(filename):
	var file = File.new()
	file.open(filename, file.READ)
	dialog_dict = JSON.parse(
		file.get_as_text()
	).result
	file.close()
	
func _display_current():
	current_node = dialog_dict['graphs'][current_state][current_node_id]
	_arrange_buttons(len(current_node['answers']))
	
	var text_id = current_node['tid']
	label.text = dialog_dict['texts'][text_id]
	
	for i in len(current_node['answers']):
		text_id = current_node['answers'][i]['tid']
		buttons[i].text = dialog_dict['texts'][text_id]
		
func _display():
	_display_current()
	var trigger_id = current_node['trigger_id']
	if trigger_id != null:
		EventBus.emit_signal("trigger", trigger_id)
		
func _arrange_buttons(answer_count):
	if answer_count < 3:
		label.rect_min_size.y = 288
		upper_h_box.visible = false
	else:
		label.rect_min_size.y = 232
		upper_h_box.visible = true
	for i in 4:
		buttons[i].visible = not ((i + 1) > answer_count)

func _process_answer(answer_index):
	var trigger_id = current_node['answers'][answer_index]['trigger_id']
	if trigger_id != null:
		EventBus.emit_signal("trigger", trigger_id)
		
	var next_node_id = current_node['answers'][answer_index]['nid']
	if next_node_id == null:
		ViewportManager.change_to_transparent()
	else:
		current_node_id = next_node_id
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
		"dialog_dict": dialog_dict,
		"current_state": current_state,
		"current_node_id": current_node_id,
		"current_node": current_node
	}
	
func restore_state(state):
	dialog_dict = state['dialog_dict']
	current_state = state['current_state']
	current_node_id = state['current_node_id']
	current_node = state['current_node']
	if not dialog_dict.empty():
		_display_current()
