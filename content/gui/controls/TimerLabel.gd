extends Label

var _timer_value = 0
var _timer_running = false

func persistent_state():
	return {
		'timer_value': _timer_value,
		'timer_running': _timer_running
	}

func restore_state(state):
	_timer_value = state['timer_value']
	_timer_running = state['timer_running']
	if _timer_running:
		visible = true

func _ready():
	visible = false
	GameStateController.connect("sig_hunger_changed", self, "_on_hunger_changed")
	call_deferred("_handle_hunger", GameStateController.hunger)
	
func _process(delta):
	if _timer_running:
		_timer_value -= delta
		_display_timer()
	
func _display_timer():
	var total_seconds = max(floor(_timer_value), 0)
	var minutes = floor(total_seconds / 60)
	var seconds = total_seconds - (minutes * 60)
	
	var minutes_string = "%02d" % minutes
	var seconds_string = "%02d" % seconds

	text = minutes_string + ":" + seconds_string

func _handle_hunger(hunger):
	if hunger < 2:
		_stop_timer()
	elif not _timer_running:
		_start_timer()

func _on_hunger_changed(hunger):
	_handle_hunger(hunger)

func _start_timer():
	_timer_value = GameStateController.hunger_timer_start_value
	_timer_running = true
	visible = true
	
func _stop_timer():
	_timer_running = false
	visible = false
