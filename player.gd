extends Area2D


export var speed = 3
var tile_size = 64

onready var movementRay = $RayCast2DMovement
onready var triggerRay = $RayCast2DTrigger

onready var tween = $Tween
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

var up_pressed = false
var down_pressed = false
var left_pressed = false
var right_pressed = false

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


var dx = 0
var dy = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.LEFT * tile_size/2
	
	looking_direction = Vector2.DOWN
	
	
func _process(delta):
	if not tween.is_active():
		if down_pressed:
			looking_direction = Vector2.DOWN
			move('down')
		if up_pressed:
			looking_direction = Vector2.UP
			move('up')
		if left_pressed:
			looking_direction = Vector2.LEFT
			move('left')
		if right_pressed:
			looking_direction = Vector2.RIGHT
			move('right')
		$Sprite.frame = idle_frame_idxs[looking_direction]
	
	else:
		animation_counter += delta
		if animation_counter > animation_period:
			animation_counter = 0
			movement_frame_idx = (movement_frame_idx + 1) % len(movement_frame_idxs[looking_direction])
			$Sprite.frame = movement_frame_idxs[looking_direction][movement_frame_idx]

		
	
func move_tween(dir):
	tween.interpolate_property(self, "position",
		position, position + inputs[dir] * tile_size,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func move(dir):
	triggerRay.cast_to = inputs[dir] * tile_size
	triggerRay.force_raycast_update()		
	if triggerRay.is_colliding():
		var collider = triggerRay.get_collider()
		if collider.get("is_activated_by_collision") != null:
			if collider.is_activated_by_collision:
				collider.trigger_collision()
			if collider.walkable:
				move_tween(dir)
	else:
		movementRay.cast_to = inputs[dir] * tile_size
		movementRay.force_raycast_update()		
		if not movementRay.is_colliding():
			move_tween(dir)
	
			
func get_tilesize():
	return tile_size


func _on_InputUI_down_pressed():
	down_pressed = true


func _on_InputUI_down_released():
	down_pressed = false


func _on_InputUI_left_pressed():
	left_pressed = true


func _on_InputUI_left_released():
	left_pressed = false


func _on_InputUI_right_pressed():
	right_pressed = true
	

func _on_InputUI_right_released():
	right_pressed = false


func _on_InputUI_up_pressed():
	up_pressed = true
	

func _on_InputUI_up_released():
	up_pressed = false


func _on_NativeCameraController_got_image(image):
	var texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	$Sprite.texture = texture
