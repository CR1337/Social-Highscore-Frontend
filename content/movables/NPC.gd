tool
extends Area2D

var _directions = {
	'down': Vector2.DOWN,
	'left': Vector2.LEFT,
	'right': Vector2.RIGHT,
	'up': Vector2.UP,
	'wait': Vector2.ZERO
}

onready var _ray = $MovementRay
onready var _tween = $Tween
onready var _sprite = $AnimatedSprite
onready var _trigger_area = $TriggerArea

const _movement_json_path = "res://movements"
const _dialog_json_path = "res://dialogs"
const _upper_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

export var ignores_crosswalks = true
export var initial_state = 'idle'

export var is_sitting = false setget set_is_sitting, get_is_sitting
func set_is_sitting(value):
	is_sitting = value
func get_is_sitting():
	return is_sitting

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

#export var movement_filename: String setget set_movement_filename, get_movement_filename
#func set_movement_filename(value):
#	movement_filename = value
#func get_movement_filename():
#	return movement_filename

#export var dialog_filename: String setget set_dialog_filename, get_dialog_filename
#func set_dialog_filename(value):
#	dialog_filename = value
#func get_dialog_filename():
#	return dialog_filename

export var speed: float setget set_speed, get_speed
func set_speed(value):
	speed = value
func get_speed():
	return speed

export var active_on_start: bool


export var animation: SpriteFrames setget set_animation, get_animation
func set_animation(value):
	animation = value
	$AnimatedSprite.frames = animation
func get_animation():
	return animation

export var current_position: Vector2 setget set_current_position, get_current_position
func set_current_position(value):
	current_position = value
	position = current_position * Globals.tile_size + Vector2.ONE * Globals.tile_size / 2
func get_current_position():
	return current_position

var _active = false

var announced_position: Vector2


export var looking_direction = Vector2.DOWN setget set_looking_direction, get_looking_direction
func set_looking_direction(value):
	looking_direction = value
	_update_animation()
func get_looking_direction():
	return looking_direction

var state =  "idle"

var _is_new_state_requested = false
var _requested_state: String

var _movement_dict: Dictionary
var _movement_step_index = 0
var _movement_step_repeat_counter = 0
var _movement_sequence_repeat_counter = 0
var _movement_waiting = false
var _movement_waiting_handle: int

func initialize_trigger_area():
	$TriggerArea.is_activated_by_action = is_activated_by_action
	$TriggerArea.walkable = is_activated_by_collison
	$TriggerArea.collision_trigger_id = collision_trigger_id
	$TriggerArea.action_trigger_id = action_trigger_id

func _set_raster_position(new_position):
	current_position = new_position
	position = current_position * Globals.tile_size + Vector2.ONE * Globals.tile_size / 2
	_update_announced_position()

func set_state(value):
	state = value
	if not _movement_dict.empty():
		if _movement_dict[state]['new_start_position_x'] != null and _movement_dict[state]['new_start_position_y'] != null:
			set_current_position(
				Vector2(
					_movement_dict[state]['new_start_position_x'],
					_movement_dict[state]['new_start_position_y']
					)
				)
	_update_animation()
	_movement_step_index = 0
	_movement_step_repeat_counter = 0
	_movement_sequence_repeat_counter = 0
	_update_announced_position()


func _update_announced_position():
	if _movement_dict.empty() || state == 'idle':
		announced_position = current_position
	else:
		announced_position = current_position + _directions[_get_movement_step()['direction']]

func request_state_change(new_state):
	_requested_state = new_state
	_is_new_state_requested = true

func _ready():
	initialize_trigger_area()
	_active = active_on_start
	var movement_filename = _get_movement_json_filename()
	var file = File.new()
	if file.file_exists(movement_filename):
		file.open(movement_filename, file.READ)
		_movement_dict = JSON.parse(
			file.get_as_text()
		).result
		file.close()
	set_state(initial_state)
	_set_raster_position(current_position)
	announced_position = current_position

func _process(delta):
	visible = true
	if _is_new_state_requested:
		set_state(_requested_state)
		_is_new_state_requested = false
	if _active and not _movement_waiting and not _movement_dict.empty():
		_move()

func _is_ray_colliding(_ray, factor = 1):
	_ray.cast_to = looking_direction * Globals.tile_size * factor
	_ray.force_raycast_update()
	return _ray.is_colliding()

func _can_move():
	if _is_ray_colliding(_ray):
		return false
	for npc in get_tree().get_nodes_in_group("npcs"):
		if npc == self:
			continue
		if npc.state == 'idle':
			continue
		if npc.get_parent() != self.get_parent():
			continue
		if npc.get("announced_position") == null or npc.get("current_position") == null :
			continue
		if (
			npc.announced_position == announced_position
			or npc.current_position == announced_position
		):
			if str(self.get_path()) > str(npc.get_path()):
				return false
	return true

func _move_tween():
	_tween.interpolate_property(self, "position",
		position, position + looking_direction * Globals.tile_size,
		1.0 / speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_tween.start()

func _update_animation():
	var animation_name_prefix = ""
	var animation_name_suffix = ""
	if _tween != null && _tween.is_active():
		animation_name_prefix = "walk"
	elif is_sitting:
		animation_name_prefix = "sitting"
	else:
		animation_name_prefix = "idle"

	match looking_direction:
		Vector2.LEFT:
			animation_name_suffix = "left"
		Vector2.RIGHT:
			animation_name_suffix = "right"
		Vector2.UP:
			animation_name_suffix = "up"
		Vector2.DOWN:
			animation_name_suffix = "down"
			
	if not _movement_dict.empty():
		if _get_movement_step()['direction'] != 'wait':
			animation_name_suffix = _get_movement_step()['direction']
	$AnimatedSprite.animation = animation_name_prefix + "_" + animation_name_suffix

func _move():
	if not _tween.is_active():
		if _get_movement_step()['direction'] == 'wait':
			_update_animation()
			_movement_waiting = true
			_movement_waiting_handle = TimeController.setTimer(_get_movement_step()['seconds'], self, "timer")
		else:
			looking_direction = _directions[_get_movement_step()['direction']]
			if _can_move():
				_move_tween()
				_next_movement_step_repeat()
				current_position = announced_position
				_update_announced_position()
			else:
				_update_animation()

func _get_movement_step():
	return _movement_dict[state]['sequence'][_movement_step_index]

func _next_movement_step():

	if _get_movement_step()['trigger_id'] != null:
		EventBus.emit_signal("sig_trigger", _get_movement_step()['trigger_id'], {})
	_movement_step_index += 1
	if _movement_step_index >= len(_movement_dict[state]['sequence']):
		if str(_movement_dict[state]['repeats']) != 'infinity':
			if _movement_sequence_repeat_counter >= _movement_dict[state]['repeats'] -1:
				set_state('idle')
			else:
				_movement_sequence_repeat_counter += 1
		_movement_step_index = 0

func _next_movement_step_repeat():
	_update_animation()
	_movement_step_repeat_counter += 1
	if _movement_step_repeat_counter >= _get_movement_step()['repeats']:
		_movement_step_repeat_counter = 0
		_next_movement_step()

func timer(handle):
	if _movement_waiting_handle == handle:
		_movement_waiting = false
		_next_movement_step()

func start_dialog():
	if _is_new_state_requested:
		set_state(_requested_state)
		_is_new_state_requested = false
	ViewportManager.change_to_dialog(_get_dialog_json_filename(), state)
	
func _split_by_capitals(string):
	var splits = []
	var current_split = ""
	for c in string:
		if c in _upper_chars:
			splits.append(current_split)
			current_split = ""
		current_split += c
	splits.append(current_split)
	return splits
	
func _get_json_filename():
	var parent_splits = _split_by_capitals(get_parent().name)
	parent_splits = parent_splits.slice(1, len(parent_splits) - 2)
	var result = ""
	for split in parent_splits:
		result += "/" + split.to_lower()
		
	result += "/"
		
	var self_splits = _split_by_capitals(name)
	self_splits = self_splits.slice(1, len(self_splits) - 1)
	for split in self_splits:
		result += split + "_"
	
	result = result.trim_suffix("_")
	result += ".json"
	return result
	
func _get_movement_json_filename():
	return "res://movements" + _get_json_filename()
	
func _get_dialog_json_filename():
	return "res://dialogs" + _get_json_filename()

func persistent_state():
	return {
		"current_position_x": current_position.x,
		"current_position_y": current_position.y,
		"active": _active,
		"announced_position_x": announced_position.x,
		"announced_position_y": announced_position.y,
		"looking_direction_x": looking_direction.x,
		"looking_direction_y": looking_direction.y,
		"state": state,
		"is_new_state_requested": _is_new_state_requested,
		"requested_state": _requested_state,
		"movement_dict": _movement_dict,
		"movement_step_index": _movement_step_index,
		"movement_step_repeat_counter": _movement_step_repeat_counter,
		"movement_waiting": _movement_waiting,
		"movement_waiting_handle": _movement_waiting_handle,
	}

func restore_state(jsonstate):
	if str(get_path()) == "/root/mainScene/Areas/LivingHomestreetArea/Car1_1":
		pass
	set_current_position(Vector2(jsonstate['current_position_x'], jsonstate['current_position_y']))
	_active =  jsonstate['active']
	announced_position = (Vector2(jsonstate['announced_position_x'], jsonstate['announced_position_y']))
	looking_direction = (Vector2(jsonstate['looking_direction_x'], jsonstate['looking_direction_y']))
	state = jsonstate['state']
	_is_new_state_requested = jsonstate['is_new_state_requested']
	_requested_state = jsonstate['requested_state']
	_movement_dict = jsonstate['movement_dict']
	_movement_step_index = jsonstate['movement_step_index']
	_movement_step_repeat_counter = jsonstate['movement_step_repeat_counter']
	_movement_waiting = jsonstate['movement_waiting']
	_movement_waiting_handle = jsonstate['movement_waiting_handle']
