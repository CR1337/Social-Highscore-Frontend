extends "res://content/trigger/Trigger.gd"


func trigger(kwargs):
	.trigger(kwargs)
	if not _blocked:
		EventBus.emit_signal("sig_trigger", "tid_read_citizen_record", {})
	else:
		ViewportManager.change_to_dialog(blocked_dialog_filename, _block_state)

