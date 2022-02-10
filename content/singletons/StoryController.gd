extends Node

var day01_bus_enabled = true
var day01_progress = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
var day01_states = [
	'initial',
	'read_moms_message',
	'goto_mom',
	'goto_pharmacy',
	'bring_meds',
	'goto_bed',
	'finished'
]
	
func day01_update_progress(new_state):
	day01_progress = day01_states.find(new_state)
	if new_state != 'read_moms_message':
		if EventBus.is_connected("sig_opened_message", self, "day01_on_opened_moms_message"):
			EventBus.disconnect("sig_opened_message", self, "day01_on_opened_moms_message")
	if new_state == 'finished':
		day01_end()
	
func day01_start():
	TimeController.fast_forward_to(10, 00)
	EventBus.emit_signal("sig_got_phone_message", 'mom', "I hope you had a good night's sleep. Could you stop by for a moment. You don't have far to go, you just have to cross the street. I'm not feeling so well again today. My illness is making itself felt.")
	TimeController.set_alarm(14, 00, self, "day01_second_mom_message")
	TimeController.set_alarm(20, 00, self, "day01_mom_dies")
	TimeController.set_alarm(13, 00, self, "day01_get_your_job")
	day01_update_progress('read_moms_message')
	EventBus.connect("sig_opened_message", self, "day01_on_opened_moms_message")
	EventBus.connect("sig_trigger", self, "day01_on_trigger")

func day01_second_mom_message(handle):
	if day01_progress >= day01_states.find('goto_mom'):
		return
	EventBus.emit_signal("sig_got_phone_message", 'mom', "Weren't you going to come over? I really need you. Please hurry.")

func day01_mom_dies(handle):
	if day01_progress < day01_states.find('goto_bed'):
		ViewportManager.change_to_gameover('mom_died')
		
func day01_get_your_job(handle):
	CitizenRecord.add_no_job(-5)
	#CitizenRecord

func day01_on_opened_moms_message(contact):
	day01_update_progress('goto_mom')
	
func day01_on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_day01_talked_to_mom':
			EventBus.emit_signal(
				"sig_trigger", 
				"tid_living_pharmacystreet_pharmacy_npc_counter_state_change",
				{'new_state': 'selling'}
			)
			EventBus.emit_signal(
				"sig_trigger", 
				"tid_living_homestreet_mom_npc_mom_state_change",
				{'new_state': 'day01_waiting_for_meds'}
			)
			day01_update_progress('goto_pharmacy')
		'tid_bought_meds':
			EventBus.emit_signal(
				"sig_trigger", 
				"tid_living_pharmacystreet_pharmacy_npc_counter_state_change",
				{'new_state': 'idle'}
			)
			EventBus.emit_signal(
				"sig_trigger", 
				"tid_living_homestreet_mom_npc_mom_state_change",
				{'new_state': 'day01_waiting_for_bought_meds'}
			)
			day01_update_progress('bring_meds')
		'tid_day01_brought_meds':
			EventBus.emit_signal(
				"sig_trigger", 
				"tid_living_homestreet_mom_npc_mom_state_change",
				{'new_state': 'day01_got_meds'}
			)
			EventBus.emit_signal(
				"sig_trigger", 
				"tid_living_friendstreet_partner_npc_partner_state_change",
				{'new_state': 'day01_react_to_tiredness'}
			)
			day01_update_progress('goto_bed')
		'tid_bed':
			if day01_progress < day01_states.find('goto_bed'):
				ViewportManager.change_to_dialog(
					"res://dialogs/other/bed_self_talk.json",
					"todo"
				)
			elif TimeController.is_before(18,00):
				ViewportManager.change_to_dialog(
					"res://dialogs/other/bed_self_talk.json",
					"early"
				)
			else:
				day01_update_progress('finished')
	
func day01_end():
	EventBus.disconnect("sig_trigger", self, "day01_on_trigger")
	TimeController.next_day(7, 00)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
