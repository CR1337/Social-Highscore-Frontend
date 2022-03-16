extends "res://content/singletons/story_controllers/StoryController.gd"

const _police_enter_trigger_id = "tid_city_policestreet_leave_police"

func _ready():
	states = [
		'talk_to_partner'
	]
	._ready()

func activate():
	.activate()
	_block_trigger(_police_enter_trigger_id, 'no_duty')
	
func deactivate():
	.deactivate()
	_unblock_trigger(_police_enter_trigger_id)
	
func _partner_message():
	_send_phone_message('partner', "day07_partner_message")
	
#func _publish_community_score_news():
#	_publish_news('nid_day07')

func _update_progress(new_state):
	._update_progress(new_state)
	match new_state:
		'talk_to_partner':
			TimeController.setTimer(7, self, "_partner_message")
#			TimeController.setTimer(1, self, "_publish_community_score_news")

func start_day():
	.start_day()
	_set_npc_visibility('friend', 'none')
	_update_progress('talk_to_partner')

func _on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_day07_talked_to_partner':
			_update_progress('goto_bed')
			GameStateController.increase_hunger()
			_request_state_change(
				_state_change_trigger_ids['partner'],
				'day07_talked_to_partner'
			)
		_: 
			._on_trigger(trigger_id, kwargs)

func _end_day():
	._end_day()
	StoryController08.start_day()
