tool
extends Area2D

var directions = {
	'down': Vector2.DOWN,
	'left': Vector2.LEFT,
	'right': Vector2.RIGHT,
	'up': Vector2.UP,
	'wait': Vector2.ZERO
}

onready var ray = $MovementRay
onready var tween = $Tween
onready var sprite = $AnimatedSprite
onready var trigger_area = $TriggerArea

export var ignores_crosswalks = true

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

export var movement_filename: String setget set_movement_filename, get_movement_filename
func set_movement_filename(value):
	movement_filename = value
func get_movement_filename():
	return movement_filename
	
export var dialog_filename: String setget set_dialog_filename, get_dialog_filename
func set_dialog_filename(value):
	dialog_filename = value
func get_dialog_filename():
	return dialog_filename

export var speed: float setget set_speed, get_speed
func set_speed(value):
	speed = value
func get_speed():
	return speed
	
export var active_on_start: bool
var active = false

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


export var is_invisible_on_idle: bool setget set_is_invisible_on_idle, get_is_invisible_on_idle
func set_is_invisible_on_idle(value):
	is_invisible_on_idle = value
func get_is_invisible_on_idle():
	return is_invisible_on_idle

var announced_position: Vector2


var looking_direction = Vector2.DOWN

var state: String
	
var is_new_state_requested = false
var requested_state: String

var movement_dict: Dictionary
var movement_step_index = 0
var movement_step_repeat_counter = 0
var movement_sequence_repeat_counter = 0
var movement_waiting = false
var movement_waiting_handle: int

func initialize_trigger_area():
	$TriggerArea.is_activated_by_action = is_activated_by_action
	$TriggerArea.walkable = is_activated_by_collison
	$TriggerArea.collision_trigger_id = collision_trigger_id
	$TriggerArea.action_trigger_id = action_trigger_id

func set_raster_position(new_position):
	current_position = new_position
	position = current_position * Globals.tile_size + Vector2.ONE * Globals.tile_size / 2
	update_announced_position()
	
func set_state(value):
	state = value
	if state != 'idle':
		visible = true
		if movement_dict[state]['new_start_position_x'] != null and movement_dict[state]['new_start_position_y'] != null:
			set_current_position(
				Vector2(
					movement_dict[state]['new_start_position_x'],
					movement_dict[state]['new_start_position_y']
					)
				)
	else:
		if is_invisible_on_idle:
			visible = false
	update_animation()
	movement_step_index = 0
	movement_step_repeat_counter = 0
	movement_sequence_repeat_counter = 0
	update_announced_position()
	

func update_announced_position():
	if state == 'idle':
		announced_position = current_position
	else:
		announced_position = current_position + directions[get_movement_step()['direction']]
		
func request_state_change(new_state):
	requested_state = new_state
	is_new_state_requested = true

func _ready():
	initialize_trigger_area()
	active = active_on_start
	var file = File.new()
	file.open(movement_filename, file.READ)
	movement_dict = JSON.parse(
		file.get_as_text()
	).result
	file.close()
	set_state('idle')
	set_raster_position(current_position)
	announced_position = current_position

func _process(delta):
	if is_new_state_requested:
		set_state(requested_state)
		is_new_state_requested = false
	if active and not movement_waiting and state != 'idle':
		move()
		
func _is_ray_colliding(ray, factor = 1):
	ray.cast_to = looking_direction * Globals.tile_size * factor
	ray.force_raycast_update()
	return ray.is_colliding()
		
func can_move():
	if _is_ray_colliding(ray):
		return false
	for npc in get_tree().get_nodes_in_group("npcs"):
		if npc == self:
			continue
		if npc.get("announced_position") == null or npc.get("current_position") == null:
			continue
		if (
			npc.announced_position == announced_position 
			or npc.current_position == announced_position
		):
			if str(self.get_path()) > str(npc.get_path()):
				return false
	return true
	
func move_tween():
	tween.interpolate_property(self, "position",
		position, position + looking_direction * Globals.tile_size,
		1.0 / speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func update_animation():
	var animation_name_prefix = ""
	var animation_name_suffix = ""
	if tween.is_active():
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
			
	if state != 'idle':
		if get_movement_step()['direction'] != 'wait':
			animation_name_suffix = get_movement_step()['direction']
	# print(animation_name_prefix + "_" + animation_name_suffix)
	sprite.animation = animation_name_prefix + "_" + animation_name_suffix
				
func move():
	if not tween.is_active():
		if get_movement_step()['direction'] == 'wait':
			update_animation()
			movement_waiting = true
			movement_waiting_handle = TimeController.setTimer(get_movement_step()['seconds'], self)
		else:
			looking_direction = directions[get_movement_step()['direction']]
			if can_move():
				move_tween()
				next_movement_step_repeat()
				current_position = announced_position
				update_announced_position()
			else:
				update_animation()
			
func get_movement_step():
	return movement_dict[state]['sequence'][movement_step_index]
			
func next_movement_step():
	
	if get_movement_step()['trigger_id'] != null:
		EventBus.emit_signal("trigger", get_movement_step()['trigger_id'])
	movement_step_index += 1
	if movement_step_index >= len(movement_dict[state]['sequence']):
		if str(movement_dict[state]['repeats']) != 'infinity':
			if movement_sequence_repeat_counter >= movement_dict[state]['repeats'] -1:
				set_state('idle')
			else:
				movement_sequence_repeat_counter += 1
		movement_step_index = 0
	
func next_movement_step_repeat():
	update_animation()
	movement_step_repeat_counter += 1
	if movement_step_repeat_counter >= get_movement_step()['repeats']:
		movement_step_repeat_counter = 0
		next_movement_step()
			
func timer(handle):
	if movement_waiting_handle == handle:
		movement_waiting = false
		next_movement_step()

func start_dialog():
	ViewportManager.change_to_dialog(dialog_filename, state)
	
func persistent_state():
	return {
		"current_position_x": current_position.x,
		"current_position_y": current_position.y,
		"active": active,
		"announced_position_x": announced_position.x,
		"announced_position_y": announced_position.y,
		"looking_direction_x": looking_direction.x,
		"looking_direction_y": looking_direction.y,
		"state": state,
		"is_new_state_requested": is_new_state_requested,
		"requested_state": requested_state,
		"movement_dict": movement_dict,
		"movement_step_index": movement_step_index,
		"movement_step_repeat_counter": movement_step_repeat_counter,
		"movement_waiting": movement_waiting,
		"movement_waiting_handle": movement_waiting_handle,
		"visible": visible
	}

func restore_state(jsonstate):
	set_current_position(Vector2(jsonstate['current_position_x'], jsonstate['current_position_y']))
	active =  jsonstate['active']
	announced_position = (Vector2(jsonstate['announced_position_x'], jsonstate['announced_position_y']))
	looking_direction = (Vector2(jsonstate['looking_direction_x'], jsonstate['looking_direction_y']))
	state = jsonstate['state']
	is_new_state_requested = jsonstate['is_new_state_requested']
	requested_state = jsonstate['requested_state']
	movement_dict = jsonstate['movement_dict']
	movement_step_index = jsonstate['movement_step_index']
	movement_step_repeat_counter = jsonstate['movement_step_repeat_counter']
	movement_waiting = jsonstate['movement_waiting']
	movement_waiting_handle = jsonstate['movement_waiting_handle']
	visible = jsonstate['visible']
