extends Area2D

export var is_activated_by_collision: bool
export var is_activated_by_action: bool
export var walkable: bool
export var collision_trigger_id: String
export var action_trigger_id: String

func trigger_collision():
	if is_activated_by_collision:
		EventBus.emit_signal("sig_trigger", collision_trigger_id)

func trigger_action():
	if is_activated_by_action:
		EventBus.emit_signal("sig_trigger", action_trigger_id)
