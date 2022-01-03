extends Node2D


export var speed = 3

onready var movementRay = $RayCast2DMovement
onready var triggerRay = $RayCast2DTrigger
onready var tween = $Tween

var looking_direction: Vector2
var idle_frame_idxs = {
	Vector2.DOWN: 1,
	Vector2.LEFT: 4,
	Vector2.RIGHT: 7,
	Vector2.UP: 10,
}
var movement_frame_idxs = {
	Vector2.DOWN: [0, 2],
	Vector2.LEFT: [3, 5],
	
	Vector2.RIGHT: [6, 8],
	Vector2.UP: [9, 11],
}
var animation_counter = 0
var movement_frame_idx = 0
export var animation_period = 0.25


var driveThroughable = false
func _ready():
	position = position.snapped(Vector2.ONE * Globals.tile_size)
	position += Vector2.ONE * Globals.tile_size / 2
	
	looking_direction = Vector2.DOWN
	
	InputBus.connect("action_pressed", self, "_on_action_pressed")
	
	
func _process(delta):
	if not tween.is_active():
		if InputBus.direction != Vector2.ZERO:
			looking_direction = InputBus.direction
			move()
		$Sprite.frame = idle_frame_idxs[looking_direction]
	else:
		animation_counter += delta
		if animation_counter > animation_period:
			animation_counter = 0
			movement_frame_idx = (movement_frame_idx + 1) % len(movement_frame_idxs[looking_direction])
			$Sprite.frame = movement_frame_idxs[looking_direction][movement_frame_idx]
	
func move_tween():
	tween.interpolate_property(self, "position",
		position, position + looking_direction * Globals.tile_size,
		1.0 / speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func _is_ray_colliding(ray):
	ray.cast_to = looking_direction * Globals.tile_size
	ray.force_raycast_update()
	return ray.is_colliding()

func move():
	# _is_ray_colliding has side effects 
	# so both calls must be done at the beginning
	var movementRay_colliding = _is_ray_colliding(movementRay)
	var triggerRay_colliding = _is_ray_colliding(triggerRay)
	
	if triggerRay_colliding:
		var collider = triggerRay.get_collider()
		if collider.get("is_activated_by_collision"):
			collider.trigger_collision()
		if collider.get("walkable") != null and not collider.get("walkable"):
			return
	if not movementRay_colliding:
		move_tween()
			
func _on_action_pressed():
	triggerRay.force_raycast_update()		
	if triggerRay.is_colliding():
		var collider = triggerRay.get_collider()
		if collider.has_method("trigger_action"):
			collider.trigger_action()