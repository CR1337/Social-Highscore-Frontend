extends Area2D

const _directions = {
	'down': Vector2.DOWN,
	'left': Vector2.LEFT,
	'right': Vector2.RIGHT,
	'up': Vector2.UP,
	'wait': Vector2.ZERO
}

onready var _tween = $Tween
onready var _sprite = $AnimatedSprite
onready var _ray = $RayCast2D

var active: bool
var _movement_dict: Dictionary
var _movement_waiting = false
var _movement_step_index = 0
var _movement_step_repeat_counter = 0
var _movement_sequence_repeat_counter = 0

var _current_position: Vector2 setget _set_current_position, _get_current_position
var movement_state = "state0"
func _set_current_position(value):
	_current_position = value
	position = _current_position * Globals.tile_size + Vector2.ONE * Globals.tile_size / 2
func _get_current_position():
	return _current_position
	
var announced_position: Vector2
var looking_direction: Vector2

export var animation: SpriteFrames setget set_animation, get_animation
func set_animation(value):
	animation = value
	$AnimatedSprite.frames = animation
func get_animation():
	return animation
export var speed = 2

func persistent_state():
	return {
		'current_position_x': _current_position.x,
		'current_position_y': _current_position.y,
		'movement_state': movement_state,
		'active': active,
		'movement_waiting': _movement_waiting,
		'movement_step_index': _movement_step_index,
		'movement_step_repeat_counter': _movement_step_repeat_counter,
		'movement_sequence_repeat_counter': _movement_sequence_repeat_counter,
		'announced_position_x': announced_position.x,
		'announced_position_y': announced_position.y,
		'looking_direction_x': looking_direction.x,
		'looking_direction_y': looking_direction.y,
	}
	
func restore_state(json_state):
	_set_current_position(Vector2(
		json_state['current_position_x'],
		json_state['current_position_y']
	))
	movement_state = json_state['movement_state']
	active = json_state['active']
	_movement_waiting = json_state['movement_waiting']
	_movement_step_index = json_state['movement_step_index']
	_movement_step_repeat_counter = json_state['movement_step_repeat_counter']
	_movement_sequence_repeat_counter = json_state['movement_sequence_repeat_counter']
	announced_position = Vector2(
		json_state['announced_position_x'],
		json_state['announced_position_y']
	)
	looking_direction = Vector2(
		json_state['looking_direction_x'],
		json_state['looking_direction_y']
	)

# BEGIN load movement dict

func _split_by_capitals(string):
	var upper_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	var splits = []
	var current_split = ""
	for c in string:
		if c in upper_chars:
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
		result += split.to_lower() + "_"
	
	result = result.trim_suffix("_")
	result += ".json"
	return result

func _load_movement_dict():
	var movement_filename = "res://movements" + _get_json_filename()
	var file = File.new()
	if file.file_exists(movement_filename):
		file.open(movement_filename, file.READ)
		_movement_dict = JSON.parse(
			file.get_as_text()
		).result
		file.close()
		
# END load movement dict

func activate():
	active = true
	_set_to_start_position()
	
func deactivate():
	active = false
	_set_current_position(Vector2(-1, -1))
	
func _set_to_start_position():
	_set_current_position(Vector2(
		_movement_dict[movement_state]['new_start_position_x'],
		_movement_dict[movement_state]['new_start_position_y']
	))
	_update_announced_position()

func _ready():
	_load_movement_dict()
	deactivate()
	activate()
	
func _process(delta):
	if active:
		if not _movement_waiting:
			_move()
		_update_animation()
		
func waiting_done(handle):
	_movement_waiting = false
	_next_movement_step()
	
func _update_animation():
	var animation_name_prefix = ""
	var animation_name_suffix = ""
	if _tween.is_active():
		animation_name_prefix = "walk"
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
		
	_sprite.animation = animation_name_prefix + "_" + animation_name_suffix
	
func _is_ray_colliding():
	_ray.cast_to = looking_direction * Globals.tile_size
	_ray.force_raycast_update()
	return _ray.is_colliding()
	
func _can_move():
	if _is_ray_colliding():
		return false
	for npc in get_tree().get_nodes_in_group("movables"):
		if npc == self:
			continue
		if npc.get_parent() != self.get_parent():
			continue
		if not npc.active:
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
	
func _update_announced_position():
	if not active or _movement_waiting:
		announced_position = _current_position
	else:
		announced_position = _current_position + _directions[_get_movement_step()['direction']]
			
func _move():
	if not _tween.is_active():
		if _get_movement_step()['direction'] == 'wait':
			_movement_waiting = true
			TimeController.setTimer(_get_movement_step()['seconds'], self, "waiting_done")
		else:
			looking_direction = _directions[_get_movement_step()['direction']]
			if _can_move():
				_move_tween()
				_next_movement_step_repeat()
				_current_position = announced_position
				_update_announced_position()

func _get_movement_step():
	return _movement_dict[movement_state]['sequence'][_movement_step_index]

func _next_movement_step():
	if _get_movement_step()['trigger_id'] != null:
		EventBus.emit_signal("sig_trigger", _get_movement_step()['trigger_id'], {})
	_movement_step_index += 1
	if _movement_step_index >= len(_movement_dict[movement_state]['sequence']):
		if str(_movement_dict[movement_state]['repeats']) != 'infinity':
			if _movement_sequence_repeat_counter >= _movement_dict[movement_state]['repeats'] -1:
				deactivate()
			else:
				_movement_sequence_repeat_counter += 1
		_movement_step_index = 0

func _next_movement_step_repeat():
	_movement_step_repeat_counter += 1
	if _movement_step_repeat_counter >= _get_movement_step()['repeats']:
		_movement_step_repeat_counter = 0
		_next_movement_step()
