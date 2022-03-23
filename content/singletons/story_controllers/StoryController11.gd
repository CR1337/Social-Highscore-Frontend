extends "res://content/singletons/story_controllers/StoryController.gd"

var _corrected_boss = false

func persistent_state():
	var state = .persistent_state()
	state['corrected_boss'] = _corrected_boss
	return state
	
func restore_state(state):
	.restore_state(state)
	_corrected_boss = state['corrected_boss']

func _ready():
	states = [
		'goto_work',
		'talk_to_boss'
	]
	._ready()

func activate():
	.activate()
	
func deactivate():
	.deactivate()

func _update_progress(new_state):
	._update_progress(new_state)
	match new_state:
		'talk_to_boss':
			_request_state_change(
				_state_change_trigger_ids['partner'],
				'day11_post_work'
			)
			_request_state_change(
				_state_change_trigger_ids['boss'],
				'day11_post_work'
			)
			EventBus.call_deferred("emit_signal", "sig_trigger", "tid_city_policestreet_police_npc_boss_start_dialog", {})
		'goto_bed':
			if not _corrected_boss:
				_request_state_change(
					_state_change_trigger_ids['boss'],
					'day11_post_debriefing'
				)

func start_day():
	.start_day()
	_update_progress('goto_work')
	_set_npc_visibility('friend', 'none')
	_set_npc_visibility('shady1', 'none')


func _on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_work_finished':
			_update_progress('talk_to_boss')
			GameStateController.increase_hunger()
		'tid_debriefing_finished':
			_update_progress('goto_bed')
		'tid_day11_corrected_boss':
			_corrected_boss = true
			_request_state_change(
				_state_change_trigger_ids['boss'],
				'day11_corrected'
			)
		_: 
			._on_trigger(trigger_id, kwargs)

func _end_day():
	StoryController12.corrected_boss = _corrected_boss
	StoryController12.start_day()
	._end_day()
