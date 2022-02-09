extends Node

var _time = 0
var _timerList
var _currentSize
var _active = true

var _current_handle = -1
var _next_handle = 0

# TODO: this needs to be emitted on every new days beginning
signal sig_new_day()

func persistent_state():
	var persistent_timer_list = []
	while _currentSize > 0:
		var element = _del_min()
		persistent_timer_list.append([
			element[0],
			element[1],
			element[2].get_path(), 
			element[3]
			])
	for element in persistent_timer_list:
		_insert([
			element[0],
			element[1],
			get_node(element[2]),
			element[3]
		])
	return {
		'time': _time,
		'timer_list': persistent_timer_list,
		'active': _active
	}

func get_daytime():
	var time = int(_time * 2)
	time = time % (Globals.seconds_per_day * 2)
	var hours = floor(time/60)
	var minutes = time % 60
	var hour_string = str(hours) if hours > 9 else "0" + str(hours)
	var minute_string = str(minutes) if minutes > 9 else "0" + str(minutes)
	return hour_string + ":" + minute_string

func restore_state(state):
	_time = state['time']
	_active = state['active']
	if len(state['timer_list']) == 0:
		return
	_timerList = [[0]]
	_currentSize = 0
	for element in state['timer_list']:
		_insert([
			element[0],
			element[1],
			get_node(element[2]),
			element[3]
		])
	
func is_before(hours, minutes): 
	var seconds = _hours_minutes_to_seconds(hours, minutes)
	var mod_seconds = int(_time) % Globals.seconds_per_day
	return seconds < mod_seconds
	
func is_after(hours, minutes):
	return not is_before(hours, minutes)
		
func next_day(hours, minutes):
	_time = ceil(int(_time) / Globals.seconds_per_day) + _hours_minutes_to_seconds(hours, minutes)
	
func _init():
	_timerList = [[0]]
	_currentSize = 0

func timer(handle):
	pass

func _process(delta):
	if _active:
		_time = _time + delta
		while _currentSize > 0 && _timerList[1][0] <= _time:
			var item = _del_min()
			item[2].call(item[3], item[1])
func _hours_minutes_to_seconds(hours, minutes):
	return hours * (Globals.seconds_per_day / 24) + minutes * (Globals.seconds_per_day / (24 * 60))

func set_alarm(hours, minutes, sender, callback):
	var seconds = floor(int(_time) / Globals.seconds_per_day) + _hours_minutes_to_seconds(hours, minutes)
	return setTimer(seconds - _time, sender, callback)

func setTimer(seconds, sender, callback):
	_current_handle = _next_handle
	_next_handle += 1
	_insert([_time + seconds, _current_handle, sender, callback])
	return _current_handle
	
func fast_forward_to(hours, minutes):
	_time = floor(int(_time) / Globals.seconds_per_day) + _hours_minutes_to_seconds(hours, minutes)
	
# Priority Queue implementation with binary heap
func _perc_up(i):
	while floor(i / 2) > 0:
		if _timerList[i][0] < _timerList[floor(i / 2)][0]:
			var tmp = _timerList[floor(i / 2)]
			_timerList[floor(i / 2)] = _timerList[i]
			_timerList[i] = tmp
		i = floor(i / 2)

func _insert(k):
	_timerList.append(k)
	_currentSize += 1
	_perc_up(_currentSize)

func _perc_down(i):
	while (i * 2) <= _currentSize:
		var mc = _min_child(i)
		if _timerList[i][0] > _timerList[mc][0]:
			var tmp = _timerList[i]
			_timerList[i] = _timerList[mc]
			_timerList[mc] = tmp
		i = mc

func _min_child(i):
	if i * 2 + 1 > _currentSize:
		return i * 2
	else:
		if _timerList[i*2][0] < _timerList[i*2+1][0]:
			return i * 2
		else:
			return i * 2 + 1

func _del_min():
	var retval = _timerList[1]
	_timerList[1] = _timerList[_currentSize]
	_timerList.remove(_currentSize)
	_currentSize -= 1
	_perc_down(1)
	return retval

func _empty():
	return _currentSize < 1



