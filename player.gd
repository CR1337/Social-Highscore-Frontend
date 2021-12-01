extends Area2D


export var speed = 3
var tile_size = 64

export var movement_cooldown = 0.2
var movement_cooldown_counter = 0

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

var dx = 0
var dy = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.LEFT * tile_size/2
	
	
func _process(delta):
	movement_cooldown_counter -= delta
	if movement_cooldown_counter < 0:
		movement_cooldown_counter = 0
	if movement_cooldown_counter == 0 and not tween.is_active():
		if down_pressed:
			move('down')
		if up_pressed:
			move('up')
		if left_pressed:
			move('left')
		if right_pressed:
			move('right')
	
func move_tween(dir):
	tween.interpolate_property(self, "position",
		position, position + inputs[dir] * tile_size,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func move(dir):
	movement_cooldown_counter = movement_cooldown
	
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
