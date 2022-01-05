extends Node

signal change_traffic_lights

var _time = 0
var _timerList
var _currentSize
var active = true

func _init():
	_timerList = [[0]]
	_currentSize = 0
	# I dont know if the time controller should care about the traffic lights... 
	setTimer(10, "traffic_toggle")

func _process(delta):
	if active:
		_time = _time + delta
		while _currentSize > 0 && _timerList[1][0] <= _time:
			var item = delMin()
			print(item)
			if item[1] == "traffic_toggle":
				setTimer(10, "traffic_toggle")
				emit_signal("change_traffic_lights")
		

func setTimer(seconds, handle):
	insert([_time + seconds, handle])

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
	_timerList.remove(_currentSize - 1)
	_currentSize -= 1
	percDown(1)
	return retval

func empty():
	return _currentSize < 1
	
func get_gametime():
	return 0
	
