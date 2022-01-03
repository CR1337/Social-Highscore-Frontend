extends Node2D


export var max_speed = 4
export var min_speed = 1
var speed: float
# path constist of tuples containing a direction and the number of tiles for that direction (e.g ('right', 8))
export var path: Array
export var texture: Texture

onready var movementRay = $RayCast2DMovement
onready var crosswalkRay = $RayCast2DCrosswalks


onready var tween = $Tween

var looking_direction: Vector2
var current_segment: int
var current_segment_idx: int
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
	'up': Vector2.UP
}

func _ready():
	position = position.snapped(Vector2.ONE * Globals.tile_size)
	position += Vector2.ONE * Globals.tile_size / 2
	current_segment = 0
	current_segment_idx = 0
	looking_direction = Vector2.DOWN
	$Sprite.texture = texture
	speed = max_speed
	
	
func _process(delta):
	if not tween.is_active():
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

func move():
	# _is_ray_colliding has side effects 
	# so call must be done at the beginning
	var movementRay_colliding = _is_ray_colliding(movementRay)
	var crosswalkRay_colliding = _is_ray_colliding(crosswalkRay, 3)

	if crosswalkRay_colliding:
		var collider = crosswalkRay.get_collider()
		if collider.get("slow_down"):
			speed = max(min_speed, 0.6*speed)
	else:
		speed = min(max_speed, 1.4*speed)
	if movementRay_colliding:
		var collider = movementRay.get_collider()
		if collider.get("walkable") != null and not collider.get("walkable"):
			return
	move_tween()
	current_segment_idx = current_segment_idx + 1
	if current_segment_idx == path[current_segment][1]:
		current_segment = (current_segment + 1) % len(path)
		current_segment_idx = 0
	
