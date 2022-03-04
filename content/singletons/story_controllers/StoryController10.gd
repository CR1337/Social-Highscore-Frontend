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
	EventBus.emit_signal("sig_got_phone_message", 'friend', "I told you the other day about my new friends. I'm meeting them the day after tomorrow, on Thursday. We'll meet at the place where we used to meet when we were at school. I would be happy if you came too. The meeting starts during your working hours, but you are welcome to join us later.")

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
			TimeController.setTimer(10, self, "friend_message")
	

func start_day():
	.start_day()
	_update_progress('goto_work')


func _on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_work_finished':
			_update_progress('goto_bed')
		_: 
			._on_trigger(trigger_id, kwargs)

func _end_day():
	._end_day()
