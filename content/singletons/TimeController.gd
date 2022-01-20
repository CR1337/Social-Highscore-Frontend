extends Node

var _time = 0
var _timerList
var _currentSize
var active = true

var current_handle = -1
var next_handle = 0

func persistent_state():
	var persistent_timer_list = []
	while _currentSize > 0:
		var element = delMin()
		persistent_timer_list.append([
			element[0],
			element[1],
			element[2].get_path()
			])
	for element in persistent_timer_list:
		insert([
			element[0], 
			element[1],
			get_node(element[2])
		])
	return {
		'time': _time,
		'timer_list': persistent_timer_list,
		'active': active
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
	active = state['active']
	if len(state['timer_list']) == 0:
		return
	_timerList = [[0]]
	_currentSize = 0
	for element in state['timer_list']:
		insert([
			element[0], 
			element[1],
			get_node(element[2])
		])

func _init():
	_timerList = [[0]]
	_currentSize = 0

func timer(handle):
	pass

func _process(delta):
	if active:
		_time = _time + delta
		while _currentSize > 0 && _timerList[1][0] <= _time:
			var item = delMin()
			print(item[2].get_path())
			item[2].timer(item[1])
		

func setTimer(seconds, sender):
	current_handle = next_handle
	next_handle += 1
	insert([_time + seconds, current_handle, sender])
	return current_handle

# Priority Queue implementation with binary heap
func percUp(i):
	while floor(i / 2) > 0:
		if _timerList[i][0] < _timerList[floor(i / 2)][0]:
			var tmp = _timerList[floor(i / 2)]
			_timerList[floor(i / 2)] = _timerList[i]
			_timerList[i] = tmp
		i = floor(i / 2)

func insert(k):
	_timerList.append(k)
	_currentSize += 1
	percUp(_currentSize)

func percDown(i):
	while (i * 2) <= _currentSize:
		var mc = minChild(i)
		if _timerList[i][0] > _timerList[mc][0]:
			var tmp = _timerList[i]
			_timerList[i] = _timerList[mc]
			_timerList[mc] = tmp
		i = mc

func minChild(i):
	if i * 2 + 1 > _currentSize:
		return i * 2
	else:
		if _timerList[i*2][0] < _timerList[i*2+1][0]:
			return i * 2
		else:
			return i * 2 + 1

func delMin():
	var retval = _timerList[1]
	_timerList[1] = _timerList[_currentSize]
	_timerList.remove(_currentSize)
	_currentSize -= 1
	percDown(1)
	return retval

func empty():
	return _currentSize < 1
	
func get_gametime():
	return 0
	
