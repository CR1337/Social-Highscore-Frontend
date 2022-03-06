extends "res://content/singletons/story_controllers/StoryController.gd"

var corrected_boss = false

func persistent_state():
	var state = .persistent_state()
	state['corrected_boss'] = corrected_boss
	return state
	
func restore_state(state):
	.restore_state(state)
	corrected_boss = state['corrected_boss']

func _ready():
	states = [
		'goto_work',
		'mission',
		'in_prison'
	]
	._ready()

func activate():
	.activate()
	
func deactivate():
	.deactivate()

func _update_progress(new_state):
	._update_progress(new_state)
	match new_state:
		'TODO':
			pass

func start_day():
	.start_day()
	_update_progress('TODO')


func _on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_TODO':
			pass
		_: 
			._on_trigger(trigger_id, kwargs)

func _end_day():
	._end_day()
