tool
extends Node2D


export var max_speed = 4
export var min_speed = 1
var speed: float
# path constist of tuples containing a direction and the number of tiles for that direction (e.g ('right', 8))
export var path: Array
export var texture: Texture setget _set_texture
var driveThrougable = false
var slowDown = 0.2

func _set_texture(value):
	texture = value
	$Sprite.texture = texture

onready var movementRay = $RayCast2DMovement
onready var slowdownRay = $RayCast2DSlowDown
onready var safetydistanceRay = $RayCast2DSafetyDistance#

var driveThroughable = false
var waiting = false

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
	position = position.snapped(Vector2.ONE * Globals.tile_size)
	position += Vector2.RIGHT * Globals.tile_size / 2
	current_segment = 0
	current_segment_idx = 0
	looking_direction = Vector2.DOWN
	speed = max_speed
	$Sprite.texture = texture
	
	
func _process(delta):
	if get_parent().get('active'):
		if not tween.is_active():
			if path[current_segment][0] == 'waiting':
				increment_segment(delta)
			else:
				looking_direction = directions[path[current_segment][0]]
				move()
			$Sprite.frame = frame_idxs[looking_direction]
	
func move_tween():
	tween.interpolate_property(self, "position",
		position, position + looking_direction * Globals.tile_size,
		1.0 / speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func _is_ray_colliding(ray, factor = 1):
	ray.cast_to = looking_direction * Globals.tile_size * factor
	ray.force_raycast_update()
	return ray.is_colliding()

func increment_segment(delta):
	current_segment_idx = current_segment_idx + delta
	if current_segment_idx >= path[current_segment][1]:
		current_segment = (current_segment + 1) % len(path)
		current_segment_idx = 0
	
func move():
	# _is_ray_colliding has side effects 
	# so call must be done at the beginning
	var movementRay_colliding = _is_ray_colliding(movementRay)
	var slowdownRay_colliding = _is_ray_colliding(slowdownRay, 2)
	var safetyDistanceRay_colliding = _is_ray_colliding(safetydistanceRay, 3) and safetydistanceRay.get_collider().get_parent() != self
	

	
	if safetyDistanceRay_colliding:
		var collider = safetydistanceRay.get_collider()
		print(self.name, " ", safetydistanceRay.get_collider().get_parent().name, " ", path[current_segment][0])
		if path[current_segment][0] == "up" or path[current_segment][0] == "down":
			return
	if slowdownRay_colliding:
		var collider = slowdownRay.get_collider()
		if collider.get("slow_down"):
			speed = max(min_speed, speed - collider.get("slow_down"))
	else:
		speed = min(max_speed, speed + 1)
	if movementRay_colliding:
		var collider = movementRay.get_collider()
		if collider.get("driveThroughable") != null and not collider.get("driveThroughable"):
			return

	move_tween()
	increment_segment(1)
