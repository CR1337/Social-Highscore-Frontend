extends Node

var _timer_list: Array
var _paused_timer_handles: Array
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
		'paused_timer_handles': _paused_timer_handles,
		'active': _active
	}
	
func _get_element_by_handle(handle):
	for element in _timer_list:
		if element[1] == handle:
			return element
	return null

func delete_timer(handle):
	_timer_list.erase(_get_element_by_handle(handle))
	
func pause_timer(handle):
	if _get_element_by_handle(handle) == null:
		return
	if not handle in _paused_timer_handles:
		_paused_timer_handles.append(handle)

func continue_timer(handle):
	if handle in _paused_timer_handles:
		_paused_timer_handles.erase(handle)
	
			
func get_remaining_seconds(handle):
	return _get_element_by_handle(handle)[0]

func restore_state(state):
	_active = state['active']
	_paused_timer_handles = state['paused_timer_handles']
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
			if element[1] in _paused_timer_handles:
				continue
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
