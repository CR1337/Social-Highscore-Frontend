extends "res://content/singletons/story_controllers/StoryController.gd"


func _ready():
	states = [
		'goto_work',
		'talk_to_friend',
		'get_food',
		'talk_to_friend_again'
	]
	._ready()
	

func _update_progress(new_state):
	._update_progress(new_state)
	
func _friend_mall_message(handle):
	EventBus.emit_signal("sig_got_phone_message", 'friend', "Hi, I'm at the mall right now. Why don't you come by and we can have a bite to eat together?")
	
func start_day():
	.start_day()
	_update_progress('goto_work')

func _on_ate_in_mall(item_key):
	if states[progress] == 'get_food':
		_update_progress('talk_to_friend_again')
		EventBus.disconnect("sig_ate_in_mall", self, "_on_ate_in_mall")
		if item_key == "fast_food":
			EventBus.emit_signal("sig_trigger", "tid_utility_busstreet_mall_npc_friend_state_change", {'new_state': "day03_ate_fast_food"})
		else:
			EventBus.emit_signal("sig_trigger", "tid_utility_busstreet_mall_npc_friend_state_change", {'new_state': "day03_not_ate_fast_food"})

func _on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_work_finished':
			GameStateController.increase_hunger()
			_update_progress('talk_to_friend')
			_set_friend_visibility('mall')
			TimeController.setTimer(4, self, '_friend_mall_message')
			_request_state_change(
				"tid_utility_busstreet_mall_npc_friend_state_change",
				'day03_talk_to_friend'
			)
		'tid_day03_talked_to_friend':
			GameStateController.increase_hunger()
			_update_progress('get_food')
			EventBus.connect("sig_ate_in_mall", self, "_on_ate_in_mall")
		'tid_day03_talked_to_friend_again':
			ViewportManager.blend_with_black()
			_set_friend_visibility('home')
			_update_progress('goto_bed')
			_request_state_change(
				"tid_living_friendstreet_friend_npc_friend_state_change",
				'day03_post_meeting'
			)
		_: 
			._on_trigger(trigger_id, kwargs)
	
func _end_day():
	._end_day()
	StoryController04.start_day()
	
