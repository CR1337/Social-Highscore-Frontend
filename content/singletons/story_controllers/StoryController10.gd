extends "res://content/singletons/story_controllers/StoryController.gd"

const _selftalk_filename = "res://dialogs/other/self_talks.json"
func _ready():
	states = [
		'goto_work'
	]
	._ready()

func activate():
	.activate()
	EventBus.connect("sig_opened_message", self, "day10_on_opened_message")
	
func deactivate():
	.deactivate()
	EventBus.disconnect("sig_opened_message", self, "day10_on_opened_message")

func friend_message(handle):
	_send_phone_message('friend', 'day10_friend_message')

func day10_on_opened_message(contact):
	if contact == 'friend' and states[progress] == 'goto_bed':
		ViewportManager.change_to_dialog(
			_selftalk_filename,
			"friend_selftalk"
		)

func _update_progress(new_state):
	._update_progress(new_state)
	match new_state:
		'goto_bed':
			TimeController.setTimer(3, self, "friend_message")
	

func start_day():
	.start_day()
	_update_progress('goto_work')


func _on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_work_finished':
			GameStateController.increase_hunger()
			_update_progress('goto_bed')
		_: 
			._on_trigger(trigger_id, kwargs)

func _end_day():
	._end_day()
	StoryController11.start_day()
