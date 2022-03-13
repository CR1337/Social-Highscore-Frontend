extends Node2D

export var speed = 3
export var is_police = false

onready var _movement_ray = $RayCast2DMovement
onready var _trigger_ray = $RayCast2DTrigger
onready var _tween = $Tween

var _looking_direction: Vector2
var _directions = {
	Vector2.DOWN: 'down',
	Vector2.LEFT: 'left',
	Vector2.RIGHT: 'right',
	Vector2.UP: 'up',
}

var _on_street = false
const _traffic_violation_countdown_duration = 1
var _traffic_violation_countdown = 0
var _entered_street = false

func _outfit_animation_prefix():
	return 'police_' if is_police else 'normal_'

func _ready():
	position = position.snapped(Vector2.ONE * Globals.tile_size)
	position -= Vector2.ONE * Globals.tile_size / 2

	_looking_direction = Vector2.DOWN

	InputBus.connect("sig_action_pressed", self, "_on_action_pressed")


func _process(delta):
	if not _tween.is_active():
		if InputBus.direction != Vector2.ZERO:
			_looking_direction = InputBus.direction
			_move()
		else:
			$AnimatedSprite.animation = _outfit_animation_prefix() +'idle_' + _directions[_looking_direction]

func move_tween():
	_tween.interpolate_property(self, "position",
		position, position + _looking_direction * Globals.tile_size,
		1.0 / speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_tween.start()

func _is_ray_colliding(ray):
	ray.cast_to = _looking_direction * Globals.tile_size
	ray.force_raycast_update()
	return ray.is_colliding()

func _colliding_with_npc():
	for npc in get_tree().get_nodes_in_group("npcs"):
		if npc.get_parent() != self.get_parent():
			continue
		if npc.state == 'idle':
			return true
		if npc.get("announced_position") == null or npc.get("current_position") == null :
			continue
		if (
			npc.announced_position == position / Globals.tile_size + _looking_direction
			or npc.current_position == position / Globals.tile_size + _looking_direction
		):
				return true
	return false

func _move():
	# _is_ray_colliding has side effects
	# so both calls must be done at the beginning
	var _movement_ray_colliding = _is_ray_colliding(_movement_ray)
	var _trigger_ray_colliding = _is_ray_colliding(_trigger_ray)
	if _entered_street:
		CitizenRecord.add_traffic_violation(-5, "No Crosswalk", ViewportManager.current_place_string())
		_entered_street = false

	if _trigger_ray_colliding:
		var collider = _trigger_ray.get_collider()
		if collider.get("is_activated_by_collision"):
			collider.trigger_collision()
		if collider.get("walkable") != null and not collider.get("walkable"):
			return
		if collider.name == "Street" and not _on_street:
			_on_street = true
			_entered_street = true
		elif collider.name != "Street" and _on_street:
			_on_street = false
	elif _on_street:
		_on_street = false
	if not _movement_ray_colliding and not _colliding_with_npc():
		move_tween()
		$AnimatedSprite.animation = _outfit_animation_prefix() + 'walk_' + _directions[_looking_direction]
	

func _on_action_pressed():
	_trigger_ray.force_raycast_update()
	if _trigger_ray.is_colliding():
		var collider = _trigger_ray.get_collider()
		if collider.has_method("trigger_action"):
			collider.trigger_action()

func persistent_state():
	return {
		'position_x': position.x,
		'position_y': position.y,
		'looking_direction_x': _looking_direction.x,
		'looking_direction_y': _looking_direction.y,
		'on_street': _on_street
	}

func restore_state(state):
	position = Vector2(
		state['position_x'],
		state['position_y']
	)
	_looking_direction = Vector2(
		state['looking_direction_x'],
		state['looking_direction_y']
	)
	$AnimatedSprite.animation = 'idle_' + _directions[_looking_direction]
	_on_street = state['on_street']
