extends "res://content/movables/Movable.gd"

export var should_be_penalized: bool
export var t_p_penalty_score: int
export var f_p_penalty_score: int
export var f_n_penalty_score: int

export var is_activated_by_collison: bool setget set_is_activated_by_collison, get_is_activated_by_collison
func set_is_activated_by_collison(value):
	is_activated_by_collison = value
func get_is_activated_by_collison():
	return is_activated_by_collison

export var is_activated_by_action: bool setget set_is_activated_by_action, get_is_activated_by_action
func set_is_activated_by_action(value):
	is_activated_by_action = value
func get_is_activated_by_action():
	return is_activated_by_action

export var walkable: bool setget set_walkable, get_walkable
func set_walkable(value):
	walkable = value
func get_walkable():
	return walkable

export var collision_trigger_id: String setget set_collision_trigger_id, get_collision_trigger_id
func set_collision_trigger_id(value):
	collision_trigger_id = value
func get_collision_trigger_id():
	return collision_trigger_id

export var action_trigger_id: String setget set_action_trigger_id, get_action_trigger_id
func set_action_trigger_id(value):
	action_trigger_id = value
func get_action_trigger_id():
	return action_trigger_id
	
const _dialog_json_path = "res://dialogs"
var _is_new_state_requested = false
var _requested_state: String
var _dialog_state = "default"

func _ready():
	._ready()
	initialize_trigger_area()
	
func initialize_trigger_area():
	$TriggerArea.is_activated_by_action = is_activated_by_action
	$TriggerArea.walkable = is_activated_by_collison
	$TriggerArea.collision_trigger_id = collision_trigger_id
	$TriggerArea.action_trigger_id = action_trigger_id
	
func _get_dialog_json_filename():
	return "res://dialogs" + _get_json_filename()
	
func start_dialog():
	EventBus.connect("sig_trigger", self, "_on_trigger")
	_movement_waiting = true
	ViewportManager.change_to_dialog(_get_dialog_json_filename(), _dialog_state)
	
func _handle_penalty():
	if should_be_penalized:
		MinigameController.handle_true_positive_penalty(t_p_penalty_score)
		ViewportManager.blend_with_green()
	else:
		MinigameController.handle_false_positive_penalty(f_p_penalty_score)
		ViewportManager.blend_with_red()
	
func _handle_no_penalty():
	if should_be_penalized:
		MinigameController.handle_false_negative_penalty(f_n_penalty_score)
		ViewportManager.blend_with_red()
	else:
		MinigameController.handle_true_negative_penalty()
		ViewportManager.blend_with_green()
	
func _on_trigger(trigger_id, kwargs):
	if trigger_id == "tid_minigame_penalty":
		EventBus.disconnect("sig_trigger", self, "_on_trigger")
		_handle_penalty()
		deactivate()
	elif trigger_id == "tid_minigame_no_penalty":
		EventBus.disconnect("sig_trigger", self, "_on_trigger")
		_handle_no_penalty()
		deactivate()
	
