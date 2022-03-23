extends "res://content/trigger/Trigger.gd"

export var post_authentication_trigger_id: String

func trigger(kwargs):
	.trigger(kwargs)
	if Globals.disable_authentication:
		EventBus.emit_signal("sig_trigger", post_authentication_trigger_id, {})
		return
		
	if _blocked:
		ViewportManager.change_to_dialog(
			blocked_dialog_filename,
			_block_state
		)
	else:
		ViewportManager.change_to_authentication(
			post_authentication_trigger_id
		)

