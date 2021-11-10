extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 200

var up_pressed = false
var down_pressed = false
var left_pressed = false
var right_pressed = false

var dx = 0
var dy = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dx = 0
	var dy = 0
	if down_pressed:
		dy += 1
	if up_pressed:
		dy -= 1
	if left_pressed:
		dx -= 1
	if right_pressed:
		dx += 1
		
	position += Vector2(dx, dy).normalized() * speed * delta


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
