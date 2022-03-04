extends "res://content/singletons/story_controllers/StoryController.gd"

func _ready():
	states = [
		'buy_meds',
		'bring_meds',
		'meet_friend'
	]
	._ready()

func activate():
	.activate()
	
func deactivate():
	.deactivate()

func friend_message(handle):
	EventBus.emit_signal("sig_got_phone_message", 'friend', "I need to talk to you urgently. Please come into town quickly. I'm in one of the side streets south of the bus stop.")

func _update_progress(new_state):
	._update_progress(new_state)
	match new_state:
		'buy_meds':
			_set_friend_visibility('none')
			EventBus.emit_signal("sig_got_phone_message", 'mom', "Hello darling, Can you please buy me medicine again?")
			_request_state_change(
				"tid_living_pharmacystreet_pharmacy_npc_counter_state_change",
				'selling'
			)
		'bring_meds':
			_request_state_change(
				"tid_living_pharmacystreet_pharmacy_npc_counter_state_change",
				'idle'
			)
			_request_state_change(
				_state_change_trigger_ids['mom'],
				'day08_waiting_for_bought_meds'
			)
		'meet_friend':
			TimeController.setTimer(3, self, "friend_message")
			_set_friend_visibility('shadystreet')
			_request_state_change(
				_state_change_trigger_ids['mom'],
				'day08_got_meds'
			)
		'goto_bed':
			_set_friend_visibility('home')
			ViewportManager.blend_with_black()
			_request_state_change(
				_state_change_trigger_ids['partner'],
				'day08_met_friend'
			)

func start_day():
	.start_day()
	_update_progress('buy_meds')


func _on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_bought_meds':
			_update_progress('bring_meds')
		'tid_day08_brought_meds':
			_update_progress('meet_friend')
		'tid_day08_talked_with_friend':
			_update_progress('goto_bed')
		_: 
			._on_trigger(trigger_id, kwargs)

func _end_day():
	._end_day()
	StoryController09.start_day()
