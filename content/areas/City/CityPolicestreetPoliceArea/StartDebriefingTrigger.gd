extends "res://content/trigger/Trigger.gd"

func trigger(kwargs):
	.trigger(kwargs)
	ViewportManager.change_to_debriefing()
	if (GameStateController.current_day + 1) % 7 > 2:
		EventBus.emit_signal("sig_trigger", "tid_city_policestreet_police_npc_boss_state_change", {'new_state': 'post_work'})
	else:
		EventBus.emit_signal("sig_trigger", "tid_city_policestreet_police_npc_boss_state_change", {'new_state': 'post_work_weekend'})
