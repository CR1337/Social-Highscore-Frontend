extends "res://content/singletons/story_controllers/StoryController.gd"

onready var _citizen_record_trigger_area = get_node("/root/Areas/LivingFriendstreetPartnerArea/CitizenRecordTriggerArea")

func _ready():
	states = [
		'goto_partner',
		'partner_away'
	]
	._ready()

func activate():
	_citizen_record_trigger_area.visible = true
	.activate()
	
func deactivate():
	.deactivate()

func _update_progress(new_state):
	._update_progress(new_state)
	match new_state:
		'goto_partner':
			_partner_message()
		'partner_away':
			ViewportManager.blend_with_black()
			_block_trigger('tid_living_friendstreet_partner_leave')
			_partner_nodes['home'].set_current_position(_invisible_position)

func start_day():
	.start_day()
	_update_progress('goto_partner')


func _on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_day13_partner_away':
			_update_progress('partner_away')
		'tid_read_citizen_record':
			if states[progress] == 'partner_away':
				ViewportManager.change_to_citizen_record_overlay()
		_: 
			._on_trigger(trigger_id, kwargs)

func _end_day():
	._end_day()
	
func _partner_message():
	EventBus.emit_signal("sig_got_phone_message", 'partner', "Good morning darling. I heard that you have the day off. Why don't you come over and we'll celebrate your success yesterday.")
