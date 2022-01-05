extends Node

export var post_authentication_trigger_path: NodePath

func trigger():
	ViewportManager.change_to_authentication(
		get_node(post_authentication_trigger_path)
	)
	
