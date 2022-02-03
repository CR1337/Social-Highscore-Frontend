extends "res://content/trigger/Trigger.gd"

func _on_trigger(trigger_id):
	._on_trigger(trigger_id)
	if trigger_id == id:
		# The dialog system waits for this event in case it triggered an npc- or
		# contact- state change before it continues
		EventBus.emit_signal("sig_dialog_trigger_completed")

func trigger():
	.trigger()
