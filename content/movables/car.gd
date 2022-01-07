tool
extends Node2D

export var max_speed = 4.0
export var min_speed = 2.0
export var start_position: Vector2
var speed: float
# path constist of tuples containing a direction and the number of tiles for that direction (e.g ('right', 8))
export var path: Array

export var texture: Texture setget _set_texture
export var next_area: String
export var next_car_id: int

var slowDown = 0.2
var _starting_offset: float
var active = false

func _set_texture(value):
	texture = value
	$Sprite.texture = texture

onready var movementRay = $RayCast2DMovement
onready var slowdownRay = $RayCast2DSlowDown

var driveThroughable = true

var tile_size: int

onready var tween = $Tween

var looking_direction: Vector2
var current_segment: int
var current_segment_idx: float
var frame_idxs = {
	Vector2.DOWN: 1,
	Vector2.LEFT: 2,
	Vector2.RIGHT: 0,
	Vector2.UP: 3
}

var directions = {
	'down': Vector2.DOWN,
	'left': Vector2.LEFT,
	'right': Vector2.RIGHT,
	'up': Vector2.UP,
}

func _ready():
	tile_size = Globals.tile_size
	$Sprite.texture = texture
	looking_direction = Vector2.DOWN

func start():
	active = true
	driveThroughable = false
	current_segment = 0
	current_segment_idx = 0
	speed = max_speed
	position = start_position * tile_size + Vector2.RIGHT * tile_size/2

func _process(delta):
	if active:
		if not tween.is_active():
			if path[current_segment][0] == 'waiting':
				increment_segment(delta)
			else:
				looking_direction = directions[path[current_segment][0]]
				move()
			$Sprite.frame = frame_idxs[looking_direction]
	
func move_tween():
	tween.interpolate_property(self, "position",
		position, position + looking_direction * tile_size,
		1.0 / speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func _is_ray_colliding(ray, factor = 1):
	ray.cast_to = looking_direction * tile_size * factor
	ray.force_raycast_update()
	return ray.is_colliding()

func increment_segment(delta):
	current_segment_idx = current_segment_idx + delta
	if current_segment_idx >= path[current_segment][1]:
		current_segment = (current_segment + 1)
		current_segment_idx = 0
	if current_segment >= len(path):
		active = false
		driveThroughable = true
		TrafficController.start_next_car(next_area, next_car_id)
	
func move():
	# _is_ray_colliding has side effects 
	# so call must be done at the beginning
	var movementRay_colliding = _is_ray_colliding(movementRay)
	var slowdownRay_colliding = _is_ray_colliding(slowdownRay, 2)
	
	if slowdownRay_colliding:
		var collider = slowdownRay.get_collider()
		print(collider.name)
		if collider.get("slow_down"):
			speed = max(min_speed, speed - collider.get("slow_down"))
	else:
		speed = min(max_speed, speed + 1)
		
	if movementRay_colliding:
		var collider = movementRay.get_collider()
		
		if collider.get("player_crossing"):
			return
		if collider.get("occupied")!= null:
			if collider.get("occupied"):
				if collider.get("occupier") != self:
					return
			else:
				collider.occupy(self)
		if collider.get("driveThroughable") != null and not collider.get("driveThroughable"):
			if collider.get("occupier") != self:
				return

	move_tween()
	increment_segment(1)
