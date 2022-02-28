extends "res://content/singletons/story_controllers/StoryController.gd"

func _ready():
	states = [
		'goto_work',
		'goto_office',
		'goto_partner'
	]
	._ready()

func activate():
	.activate()
	_block_trigger('tid_city_bankstreet_leave_office', 'day06_closed')

func deactivate():
	.deactivate()
	_unblock_trigger('tid_city_bankstreet_leave_office')


func _partner_message(handle):
	EventBus.emit_signal("sig_got_phone_message", 'partner','Hi honey, my game night is about to start. <Friend> is already here too. Are you coming?')

func _update_progress(new_state):
	._update_progress(new_state)
	match new_state:
		'goto_work':
			_set_friend_visibility('home')
		'goto_office':
			_unblock_trigger('tid_city_bankstreet_leave_office')
			_request_state_change(_state_change_trigger_ids['mom'], 'day06_post_work')
			_request_state_change('tid_city_bankstreet_office_npc_counter_state_change', 'day06_idle')
		'goto_partner':
			_set_friend_visibility('partner')
			TimeController.setTimer(2, self, '_partner_message')
			_request_state_change(_state_change_trigger_ids['mom'], 'day06_post_application')
			_request_state_change(_state_change_trigger_ids['partner'], 'day06_game_evening')
			_request_state_change('tid_city_bankstreet_office_npc_counter_state_change', 'with_application_idle')
		'goto_bed':
			_set_friend_visibility('home')
			ViewportManager.blend_with_black()
			_request_state_change(_state_change_trigger_ids['partner'], 'day06_post_game_evening')
			_request_state_change(_state_change_trigger_ids['friend'], 'day06_post_game_evening')
			

func start_day():
	.start_day()
	_update_progress('goto_work')


func _on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_work_finished':
			_update_progress('goto_office')
		'tid_day06_made_application':
			_update_progress('goto_partner')
		'tid_day06_finished_games': 
			_update_progress('goto_bed')
		_: 
			._on_trigger(trigger_id, kwargs)

func _end_day():
	._end_day()
	StoryController07.start_day()
