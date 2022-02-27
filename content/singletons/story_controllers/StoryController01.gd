extends "res://content/singletons/story_controllers/StoryController.gd"

onready var _bus_trigger_id = "tid_living_busstreet_bus"

func activate():
	.activate()
	EventBus.connect("sig_opened_message", self, "day01_on_opened_moms_message")
	
func deactivate():
	.deactivate()
	EventBus.disconnect("sig_opened_message", self, "day01_on_opened_moms_message")

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
	if states.find(new_state) <= states.find('goto_bed'):
		_block_trigger(_bus_trigger_id, 'day01_' + new_state)

	match new_state:
		'goto_pharmacy':
			_request_state_change(
				"tid_living_pharmacystreet_pharmacy_npc_counter_state_change",
				'selling'
			)
			_request_state_change(
				_state_change_trigger_ids['mom'],
				'day01_waiting_for_meds'
			)
			
		'bring_meds':
			_request_state_change(
				"tid_living_pharmacystreet_pharmacy_npc_counter_state_change",
				'idle'
			)
			_request_state_change(
				_state_change_trigger_ids['mom'],
				'day01_waiting_for_bought_meds'
			)
			TimeController.setTimer(5, self, "day01_get_your_job")
		'goto_bed':
			_request_state_change(
				_state_change_trigger_ids['mom'],
				'day01_got_meds'
			)
			_request_state_change(
				_state_change_trigger_ids['partner'],
				'day01_react_to_tiredness'
			)


func start_day():
	.start_day()
	EventBus.emit_signal("sig_got_phone_message", 'mom', "I hope you had a good night's sleep. Could you stop by for a moment. You don't have far to go, you just have to cross the street. I'm not feeling so well again today. My illness is making itself felt.")
	_update_progress('read_moms_message')
	

func day01_get_your_job(handle):
	CitizenRecord.add_no_job(-5)

func day01_on_opened_moms_message(contact):
	if states[progress] == 'read_moms_message':
		_update_progress('goto_mom')
	
func _on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_day01_talked_to_mom':
			_update_progress('goto_pharmacy')
		'tid_bought_meds':
			_update_progress('bring_meds')
		'tid_day01_brought_meds':
			_update_progress('goto_bed')
			GameStateController.increase_hunger()
		_: 
			._on_trigger(trigger_id, kwargs)
	
func _end_day():
	._end_day()
	StoryController02.start_day()
