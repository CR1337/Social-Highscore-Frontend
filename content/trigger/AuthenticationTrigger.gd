extends "res://content/trigger/Trigger.gd"

export var post_authentication_trigger_id: String

func trigger():
	.trigger()
	if Globals.disable_authentication:
		EventBus.emit_signal("sig_trigger", post_authentication_trigger_id)
		return

	ViewportManager.change_to_authentication(
		post_authentication_trigger_id
	)

