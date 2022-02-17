extends Node

var _timer_list: Array
var _active = true

var _current_handle = -1
var _next_handle = 0

# TODO: this needs to be emitted on every new days beginning
signal sig_new_day()

func persistent_state():
	var persistent_timer_list = []
	for element in _timer_list:
		persistent_timer_list.append([
			element[0],
			element[1],
			element[2].get_path(), 
			element[3]
			])
	return {
		'timer_list': persistent_timer_list,
		'active': _active
	}

func delete_timer(handle):
	for element in _timer_list:
		if element[1] == handle:
			_timer_list.erase(element)
			return

func restore_state(state):
	_active = state['active']
	if len(state['timer_list']) == 0:
		return
	_timer_list = []
	for element in state['timer_list']:
		_insert([
			element[0],
			element[1],
			get_node(element[2]),
			element[3]
		])
	
func _init():
	_timer_list = []

func _process(delta):
	if _active:
		var _to_remove = []
		for element in _timer_list:
			element[0] -= delta
			if element[0] <= 0:
				element[2].call(element[3], element[1]) 
				_to_remove.append(element)
		for element in _to_remove:
			_timer_list.erase(element)

func setTimer(seconds, sender, callback):
	_current_handle = _next_handle
	_next_handle += 1
	_insert([seconds, _current_handle, sender, callback])
	return _current_handle
	
func _insert(k):
	_timer_list.append(k)
