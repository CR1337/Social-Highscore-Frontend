extends "res://content/singletons/story_controllers/StoryController.gd"


func _ready():
	states = [
		'goto_work',
		'talk_to_friend',
		'get_food',
		'talk_to_friend_again'
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
		'talk_to_friend':
			_set_npc_visibility('friend', 'mall')
			TimeController.setTimer(4, self, '_friend_mall_message')
			_request_state_change(
				"tid_utility_busstreet_mall_npc_friend_state_change",
				'day03_talk_to_friend'
			)
		'get_food':
			pass
		'goto_bed':
			ViewportManager.blend_with_black()
			_set_npc_visibility('friend', 'home')
			_request_state_change(
				_state_change_trigger_ids['friend'],
				'day03_post_meeting'
			)

func _friend_mall_message(handle):
	_send_phone_message('friend', 'day03_friend_message')
	
func start_day():
	.start_day()
	_set_npc_visibility('friend', 'home')
	_update_progress('goto_work')

func _on_ate_in_mall(item_key):
	if states[progress] == 'get_food':
		_update_progress('talk_to_friend_again')
		if item_key == "fast_food":
			_request_state_change(
				"tid_utility_busstreet_mall_npc_friend_state_change",
				"day03_ate_fast_food"
			)
		else:
			_request_state_change(
				"tid_utility_busstreet_mall_npc_friend_state_change",
				"day03_not_ate_fast_food"
			)

func _on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_work_finished':
			GameStateController.increase_hunger()
			_update_progress('talk_to_friend')
		'tid_day03_talked_to_friend':
			GameStateController.increase_hunger()
			_update_progress('get_food')
		'tid_day03_talked_to_friend_again':
			_update_progress('goto_bed')
		_: 
			._on_trigger(trigger_id, kwargs)
	
func _end_day():
	._end_day()
	StoryController04.start_day()
	
