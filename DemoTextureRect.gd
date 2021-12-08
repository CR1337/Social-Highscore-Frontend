extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	ImageProcessor.connect("image_processing_done", self, "_image_processing_done")

func _image_processing_done(response, handle, image):
	var tmp_texture = ImageTexture.new()
	tmp_texture.create_from_image(image, 0)
	texture = tmp_texture
	
	# TODO: rotate image

#	draw_set_transform(Vector2(0, 0), PI / 4.0, Vector2(1, 1))
	# draw_texture(texture, Vector2(0,0))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
