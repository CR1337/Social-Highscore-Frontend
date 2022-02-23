extends "res://content/singletons/story_controllers/StoryController.gd"

const _police_enter_trigger_id = "tid_city_policestreet_leave_police"
const _bank_enter_trigger_id = "tid_city_bankstreet_leave_bank"
const _bus_living_trigger_id = "tid_living_busstreet_bus"
const _bus_city_trigger_id = "tid_city_busstreet_bus"

func _ready():
	states = [
		'goto_partner',
		'goto_bank',
		'goto_work',
		'buy_meds',
		'bring_meds'
	]
	._ready()
	

func _update_progress(new_state):
	._update_progress(new_state)
	match new_state:
		'goto_partner':
			EventBus.emit_signal(
				"sig_trigger",
				_police_enter_trigger_id,
				{'action': 'block',
				'block_state': 'goto_bank'}
			)
			EventBus.emit_signal(
				"sig_trigger",
				_bank_enter_trigger_id,
				{'action': 'unblock'}
			)
			EventBus.emit_signal(
				"sig_trigger", 
				_bus_living_trigger_id,
				{'action': 'block',
				'block_state': 'day05_goto_partner'}
			)
			_request_state_change(
				'tid_city_bankstreet_bank_npc_counter_state_change',
				'day05_unlock_account'
			)
			_set_friend_visibility('none')
		'goto_bank':
			GameStateController.ticket_bought = true
			_request_state_change(
				'tid_living_friendstreet_partner_npc_partner_state_change',
				'day05_gave_ticket'
			)
			EventBus.emit_signal(
				"sig_trigger",
				_bus_living_trigger_id,
				{'action': 'unblock'}
			)
			EventBus.emit_signal(
				"sig_trigger",
				_police_enter_trigger_id,
				{'action': 'unblock'}
			)
		'goto_work':
			EventBus.emit_signal(
				"sig_trigger",
				_bus_city_trigger_id,
				{'action': 'block',
				'block_state': 'day05_goto_work'})
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
				'tid_living_homestreet_mom_npc_mom_state_change',
				'day05_unlocked_account'
			)
			EventBus.emit_signal(
				"sig_trigger",
				_bus_city_trigger_id,
				{'action': 'unblock'}
			)

		'bring_meds':
			_request_state_change(
				'tid_living_homestreet_mom_npc_mom_state_change',
				'day05_bring_meds'
			)
			_request_state_change(
				'tid_living_pharmacystreet_pharmacy_npc_counter_state_change',
				'idle'
			)
		'goto_bed':
			_request_state_change(
				'tid_living_homestreet_mom_npc_mom_state_change',
				'day05_got_meds'
			)

func start_day():
	.start_day()
	_update_progress('goto_partner')


func _on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_day05_got_bus_ticket':
			_update_progress('goto_bank')
		'tid_day05_unlocked_account':
			_update_progress('goto_work')
		'tid_work_finished':
			_update_progress('buy_meds')
		'tid_bought_meds':
			_update_progress('bring_meds')
		'tid_day05_brought_meds':
			_update_progress('goto_bed')
		_: 
			._on_trigger(trigger_id, kwargs)
	
func _end_day():
	._end_day()
	
