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
	
func _can_move():
	# cast Ray into looking direction
	movementRay.cast_to = looking_direction * Globals.tile_size
	movementRay.force_raycast_update()
	
	# if not colliding, player can move
	if not movementRay.is_colliding():
		return true
		
	# if collider is not TileMap, player cannot move
	var collider = movementRay.get_collider()
	if not (typeof(collider) == TYPE_OBJECT and collider.is_class("TileMap")):
		return false
		
	# if collider is TileMap, get name of the colliding tile
	var tile_coords = collider.world_to_map(movementRay.position + movementRay.cast_to)
	var tile_id = collider.get_cell(tile_coords.x, tile_coords.y)
	var tileset = collider.get_tileset()
	var tile_name = tileset.tile_get_name(tile_id)
	
	# there are special tiles that should only collide when
	# entered from a specific direction
	# eg: a tile that cannot be entered from left and below:
	# collider_ld
	var directions = tile_name.split("_")[1]
	match looking_direction:
		Vector2.LEFT:
			return not "l" in directions
		Vector2.RIGHT:
			return not "r" in directions
		Vector2.UP:
			return not "u" in directions
		Vector2.DOWN:
			return not "d" in directions
		_:
			return false

func move():
	triggerRay.cast_to = looking_direction * Globals.tile_size
	triggerRay.force_raycast_update()
	if triggerRay.is_colliding():
		var collider = triggerRay.get_collider()
		if collider.get("is_activated_by_collision") != null:
			if collider.is_activated_by_collision:
				collider.trigger_collision()
			if collider.walkable and _can_move():
				move_tween()
	elif _can_move():
			move_tween()
			
func _on_action_pressed():
	triggerRay.force_raycast_update()		
	if triggerRay.is_colliding():
		var collider = triggerRay.get_collider()
		if collider.has_method("trigger_action"):
			collider.trigger_action()

#
#func get_tilesize():
#	return Globals.tile_size
