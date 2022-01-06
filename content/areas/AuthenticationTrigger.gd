extends Node

export var post_authentication_trigger_path: NodePath

func trigger():
	# For Debugging
	if Globals.disable_authentication:
		get_node(post_authentication_trigger_path).trigger()
		return

	ViewportManager.change_to_authentication(
		get_node(post_authentication_trigger_path)
	)
	
