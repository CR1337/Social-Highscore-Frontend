extends Node2D

export(NodePath) var phone_camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_InputUI_action_pressed():
	get_node(phone_camera).take_picture()


func _on_phone_camera_picture_taken(error_code, image_texture, extras):
	$Sprite.texture = image_texture
#	var filename = "tmp.jpg"
#	var image = image_texture.get_data()
#	image.save_png(filename)
#	print(error_code)
#	print(extras)
