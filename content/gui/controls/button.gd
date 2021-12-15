extends Node2D

export(Texture) var normal_texture
export(Texture) var pressed_texture
signal is_pressed
signal is_released

export(Vector2) var size

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$TouchScreenButton.normal = normal_texture
	$TouchScreenButton.pressed = pressed_texture
	
	$TouchScreenButton.scale = size


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TouchScreenButton_pressed():
	emit_signal("is_pressed")


func _on_TouchScreenButton_released():
	emit_signal("is_released")
