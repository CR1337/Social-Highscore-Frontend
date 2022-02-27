extends "res://content/singletons/story_controllers/StoryController.gd"

func _ready():
	states = [
		'goto_jobcenter',
		'buy_choc',
		'bring_choc'
	]
	._ready()
	
func activate():
	.activate()
	EventBus.connect("sig_fridge_content_changed", self, "_on_fridge_content_changed")
	
func deactivate():
	.deactivate()
	EventBus.disconnect("sig_fridge_content_changed", self, "_on_fridge_content_changed")
	
func _update_progress(new_state):
	._update_progress(new_state)
	
	match new_state:
		'goto_jobcenter':
			_request_state_change(
				"tid_city_jobcenterstreet_jobcenter_npc_counter_state_change",
				"day02_job_offer"
			)
		'buy_choc':
			_request_state_change(
				_state_change_trigger_ids['partner'],
				'day02_buy_choc'
			)
		'bring_choc':
			_request_state_change(
				_state_change_trigger_ids['partner'],
				'day02_bring_choc'
			)
		'goto_bed':
			_request_state_change(
				_state_change_trigger_ids['partner'],
				'day02_goto_bed'
			)
			GameStateController.delete_fridge_content_by_name('chocolate')

func start_day():
	.start_day()
	_unblock_trigger('tid_living_busstreet_bus')
	_set_friend_visibility('none')
	_update_progress('goto_jobcenter')
	
func _choc_in_fridge():
	for food_item in GameStateController.fridge_content:
		if food_item['name'] == 'chocolate':
			return true
	return false
	
func _partner_choc_message(handle):
	EventBus.emit_signal("sig_got_phone_message", 'partner', "Hi honey. Can you bring me my favorite chocolate from the supermarket? You had to go shopping anyway, right?")
	
func _on_fridge_content_changed():
	if states[progress] == 'buy_choc' and _choc_in_fridge():
		_update_progress('bring_choc')
	elif states[progress] == 'bring_choc' and not _choc_in_fridge():
		_update_progress('buy_choc')
		
func _update_police_npc_states():
	for i in range(1, 5):
		var key = "police" + str(i)
		_request_state_change(
			_state_change_trigger_ids[key],
			"day02_got_job"
		)
	
func _on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_day02_got_job':
			GameStateController.increase_hunger()
			_request_state_change(
				"tid_city_jobcenterstreet_jobcenter_npc_counter_state_change",
				"idle"
			)
			_request_state_change(
				_state_change_trigger_ids['mom'],
				"day02_proud"
			)
			_request_state_change(
				_state_change_trigger_ids['boss'],
				"day02_got_job"
			)
			_update_police_npc_states()
			if _choc_in_fridge():
				_update_progress('bring_choc')
			else:
				_update_progress('buy_choc')
			TimeController.setTimer(5, self, "_partner_choc_message")
		'tid_day02_brought_choc':
			GameStateController.increase_hunger()
			_update_progress('goto_bed')
		_: 
			._on_trigger(trigger_id, kwargs)
	
func _end_day():
	._end_day()
	StoryController03.start_day()
	
