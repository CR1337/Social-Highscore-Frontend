extends Node2D

export var speed = 3

onready var movementRay = $RayCast2DMovement
onready var triggerRay = $RayCast2DTrigger
onready var tween = $Tween

var looking_direction: Vector2
var directions = {
	Vector2.DOWN: 'down',
	Vector2.LEFT: 'left',
	Vector2.RIGHT: 'right',
	Vector2.UP: 'up',
}

func _ready():
	position = position.snapped(Vector2.ONE * Globals.tile_size)
	position -= Vector2.ONE * Globals.tile_size / 2
	
	looking_direction = Vector2.DOWN
	
	InputBus.connect("action_pressed", self, "_on_action_pressed")
	
	
func _process(delta):
	if not tween.is_active():
		if InputBus.direction != Vector2.ZERO:
			looking_direction = InputBus.direction
			move()
		else:
			$AnimatedSprite.animation = 'idle_' + directions[looking_direction]			
	
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
		$AnimatedSprite.animation = 'walk_' + directions[looking_direction]
			
func _on_action_pressed():
	triggerRay.force_raycast_update()		
	if triggerRay.is_colliding():
		var collider = triggerRay.get_collider()
		if collider.has_method("trigger_action"):
			collider.trigger_action()

func persistent_state():
	return {
		'position_x': position.x,
		'position_y': position.y,
		'looking_direction_x': looking_direction.x,
		'looking_direction_y': looking_direction.y
	}
	
func restore_state(state):
	position = Vector2(
		state['position_x'],
		state['position_y']
	)
	looking_direction = Vector2(
		state['looking_direction_x'],
		state['looking_direction_y']
	)
	$AnimatedSprite.animation = 'idle_' + directions[looking_direction]
