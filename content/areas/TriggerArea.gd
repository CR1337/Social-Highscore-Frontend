extends Area2D

export var is_activated_by_collision: bool
export var is_activated_by_action: bool
export var walkable: bool
export (NodePath) var collisionTriggerPath
export (NodePath) var actionTriggerPath
	
func trigger_collision():
	if is_activated_by_collision:
		get_node(collisionTriggerPath).trigger()

func trigger_action():
	if is_activated_by_action:
		get_node(actionTriggerPath).trigger()
