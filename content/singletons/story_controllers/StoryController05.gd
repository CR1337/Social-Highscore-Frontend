extends "res://content/singletons/story_controllers/StoryController.gd"

const _police_enter_trigger_id = "tid_city_policestreet_leave_police"
const _bank_enter_trigger_id = "tid_city_bankstreet_leave_bank"
const _bus_living_trigger_id = "tid_living_busstreet_bus"
const _bus_city_trigger_id = "tid_city_busstreet_bus"

func _ready():
	states = [
		'goto_partner',
		'goto_bank',
		'unlock_account',
		'goto_work',
		'buy_meds',
		'bring_meds'
	]
	._ready()

func activate():
	.activate()
	
func deactivate():
	.deactivate()		

func _update_progress(new_state):
	._update_progress(new_state)
	match new_state:
		'goto_partner':
			_block_trigger(_police_enter_trigger_id, 'goto_bank')
			_block_trigger('tid_living_pharmacystreet_leave_pharmacy', 'account_locked')
			_block_trigger('tid_city_storestreet_leave_store', 'account_locked')
			_block_trigger('tid_utility_busstreet_leave_mall', 'account_locked')
			
			_unblock_trigger(_bank_enter_trigger_id)
			_block_trigger(_bus_living_trigger_id, 'day05_goto_partner')
			_request_state_change(
				'tid_city_bankstreet_bank_npc_counter_state_change',
				'day05_unlock_account'
			)
			_set_friend_visibility('none')
		'goto_bank':
			GameStateController.ticket_bought = true
			_request_state_change(
				_state_change_trigger_ids['partner'],
				'day05_gave_ticket'
			)
			_unblock_trigger(_bus_living_trigger_id)
		'unlocking_account':
			GameStateController.bank_account_blocked = false
		'goto_work':
			_unblock_trigger(_police_enter_trigger_id)
			_unblock_trigger('tid_living_pharmacystreet_leave_pharmacy')
			_unblock_trigger('tid_city_storestreet_leave_store')
			_unblock_trigger('tid_utility_busstreet_leave_mall')
			_block_trigger(_bus_city_trigger_id, 'day05_goto_work')
			if GameStateController.score_class() <= GameStateController.SCORE_CLASS.B:
				_request_state_change(
						"tid_city_bankstreet_bank_npc_counter_state_change",
						"idle"
					)
			elif GameStateController.score_class() == GameStateController.SCORE_CLASS.C:
				_request_state_change(
						"tid_city_bankstreet_bank_npc_counter_state_change",
						"Class C"
					)
			else:
				_request_state_change(
						"tid_city_bankstreet_bank_npc_counter_state_change",
						"Class D"
					)
		'buy_meds':
			_request_state_change(
				'tid_living_pharmacystreet_pharmacy_npc_counter_state_change',
				'selling'
			)
			_request_state_change(
				_state_change_trigger_ids['mom'],
				'day05_unlocked_account'
			)
			_unblock_trigger(_bus_city_trigger_id)
		'bring_meds':
			_request_state_change(
				_state_change_trigger_ids['mom'],
				'day05_bring_meds'
			)
			_request_state_change(
				'tid_living_pharmacystreet_pharmacy_npc_counter_state_change',
				'idle'
			)
		'goto_bed':
			_request_state_change(
				_state_change_trigger_ids['mom'],
				'day05_got_meds'
			)

func start_day():
	.start_day()
	_update_progress('goto_partner')


func _on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_day05_got_bus_ticket':
			_update_progress('goto_bank')
		'tid_day05_unlock_account':
			_update_progress('unlocking_account')
		'tid_day05_unlocked_account':
			_update_progress('goto_work')
		'tid_work_finished':
			_update_progress('buy_meds')
			GameStateController.increase_hunger()
		'tid_bought_meds':
			_update_progress('bring_meds')
		'tid_day05_brought_meds':
			_update_progress('goto_bed')
			GameStateController.increase_hunger()
		_: 
			._on_trigger(trigger_id, kwargs)
	
func _end_day():
	._end_day()
	StoryController06.start_day()
