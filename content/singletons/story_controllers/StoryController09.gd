extends "res://content/singletons/story_controllers/StoryController.gd"

func _ready():
	states = [
		'goto_work',
		'goto_mall',
		'get_food',
		'talk_to_partner_again',
		'continue_talking'
	]
	._ready()

func activate():
	.activate()
	EventBus.connect("sig_ate_in_mall", self, "_on_ate_in_mall")
	
func deactivate():
	.deactivate()
	EventBus.disconnect("sig_ate_in_mall", self, "_on_ate_in_mall")

func _update_progress(new_state):
	._update_progress(new_state)
	match new_state:
		'goto_work':
			pass
		'goto_mall':
			_set_partner_visibility('mall')
			_send_phone_message('partner', 'day09_partner_message')
			_request_state_change(
				"tid_utility_busstreet_mall_npc_partner_state_change",
				"day09_dinner"
			)
		'get_food':
			pass
		'talk_to_partner_again':
			pass
		'continue_talking':
			pass
		'goto_bed':
			_set_partner_visibility('home')
			_request_state_change(
				_state_change_trigger_ids['partner'],
				"day09_after_dinner"
			)

func start_day():
	.start_day()
	_update_progress('goto_work')

func _on_ate_in_mall(item_key):
	if states[progress] == 'get_food':
		_update_progress('talk_to_partner_again')
		if item_key == "fruits":
			_request_state_change(
				"tid_utility_busstreet_mall_npc_partner_state_change",
				"day09_ate_fruits"
			)
		else:
			_request_state_change(
				"tid_utility_busstreet_mall_npc_partner_state_change",
				"day09_not_ate_fruits"
			)

func _on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_work_finished':
			_update_progress('goto_mall')
		'tid_day09_talked_to_partner':
			_update_progress('get_food')
		'tid_day09_continue_talk':
			_update_progress('continue_talking')
		'tid_day09_finished_talk':
			_update_progress('goto_bed')
		_: 
			._on_trigger(trigger_id, kwargs)

func _end_day():
	._end_day()
