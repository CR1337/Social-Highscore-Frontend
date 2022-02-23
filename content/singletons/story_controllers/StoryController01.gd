extends "res://content/singletons/story_controllers/StoryController.gd"

onready var _bus_trigger_id = "tid_living_busstreet_bus"

func _ready():
	states = [
		'read_moms_message',
		'goto_mom',
		'goto_pharmacy',
		'bring_meds'
	]
	._ready()
	
func _update_progress(new_state):
	._update_progress(new_state)
	EventBus.emit_signal(
		"sig_trigger", 
		_bus_trigger_id,
		{'action': 'block',
		'block_state': 'day01_' + new_state}
	)
	if new_state != 'read_moms_message':
		if EventBus.is_connected("sig_opened_message", self, "day01_on_opened_moms_message"):
			EventBus.disconnect("sig_opened_message", self, "day01_on_opened_moms_message")

func start_day():
	.start_day()
	EventBus.emit_signal("sig_got_phone_message", 'mom', "I hope you had a good night's sleep. Could you stop by for a moment. You don't have far to go, you just have to cross the street. I'm not feeling so well again today. My illness is making itself felt.")
	_update_progress('read_moms_message')
	EventBus.connect("sig_opened_message", self, "day01_on_opened_moms_message")

func day01_get_your_job(handle):
	CitizenRecord.add_no_job(-5)

func day01_on_opened_moms_message(contact):
	_update_progress('goto_mom')
	
func _on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_day01_talked_to_mom':
			_request_state_change(
				"tid_living_pharmacystreet_pharmacy_npc_counter_state_change",
				'selling'
			)
			_request_state_change(
				"tid_living_homestreet_mom_npc_mom_state_change",
				'day01_waiting_for_meds'
			)
			_update_progress('goto_pharmacy')
		'tid_bought_meds':
			_request_state_change(
				"tid_living_pharmacystreet_pharmacy_npc_counter_state_change",
				'idle'
			)
			_request_state_change(
				"tid_living_homestreet_mom_npc_mom_state_change",
				'day01_waiting_for_bought_meds'
			)
			TimeController.setTimer(5, self, "day01_get_your_job")
			_update_progress('bring_meds')
		'tid_day01_brought_meds':
			_request_state_change(
				"tid_living_homestreet_mom_npc_mom_state_change",
				'day01_got_meds'
			)
			_request_state_change(
				"tid_living_friendstreet_partner_npc_partner_state_change",
				'day01_react_to_tiredness'
			)
			GameStateController.increase_hunger()
			_update_progress('goto_bed')
		_: 
			._on_trigger(trigger_id, kwargs)
	
func _end_day():
	._end_day()
	EventBus.emit_signal(
		"sig_trigger", 
		_bus_trigger_id,
		{'action': 'unblock'}
	)
	StoryController02.start_day()
