extends "res://content/trigger/Trigger.gd"

var kidney_donated = false

func trigger(kwargs):
	.trigger(kwargs)
	if kidney_donated:
		EventBus.emit_signal("sig_trigger",
		"tid_utility_busstreet_hospital_npc_counter_state_change",
		{'new_state': "kidney donated"})
	else:
		EventBus.emit_signal("sig_trigger",
		"tid_utility_busstreet_hospital_npc_counter_state_change",
		{'new_state': "idle"})
