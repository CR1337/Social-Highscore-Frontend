extends "res://content/singletons/story_controllers/StoryController.gd"

const _bank_enter_trigger_id = "tid_city_bankstreet_leave_bank"

func _ready():
	states = [
		'goto_work',
		'buy_meds',
		'goto_bank'
	]
	._ready()
	
func activate():
	.activate()
	
func deactivate():
	.deactivate()	

func _update_progress(new_state):
	._update_progress(new_state)
	match new_state:
		'buy_meds':
			_send_phone_message('mom', 'day04_mom_message')
			_block_trigger(_bank_enter_trigger_id)
			GameStateController.bank_account_blocked = true
			_request_state_change(
				"tid_living_pharmacystreet_pharmacy_npc_counter_state_change",
				'selling'
			)
			_request_state_change(
				_state_change_trigger_ids['mom'],
				'day04_post_message'
			)
		'goto_bank':
			_request_state_change(
				_state_change_trigger_ids['mom'],
				'day04_post_pharmacy'
			)
		'goto_bed':
			_request_state_change(
					_state_change_trigger_ids['mom'],
					'day04_post_bank'
				)

func start_day():
	.start_day()
	_update_progress('goto_work')
	_set_npc_visibility('friend', 'none')


func _on_trigger(trigger_id, kwargs):
	
	match trigger_id:
		'tid_work_finished':
			_update_progress('buy_meds')
			GameStateController.increase_hunger()
		'tid_failed_to_buy_meds':
			_update_progress('goto_bank')
		'tid_city_bankstreet_leave_bank':
			if states[progress] == 'goto_bank':
				GameStateController.increase_hunger()
				_update_progress('goto_bed')
		_: 
			._on_trigger(trigger_id, kwargs)

func _end_day():
	._end_day()
	StoryController05.start_day()
	
