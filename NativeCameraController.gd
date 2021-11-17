extends Node

var imagePlugin
signal got_image(image)

func _ready():
	if Engine.has_singleton("GodotGetImage"):
		imagePlugin = Engine.get_singleton("GodotGetImage")
		imagePlugin.connect("image_request_completed", self, "_received_image") 

func _received_image(dict):
	for image in dict.values():
		var currentImage = Image.new()
		currentImage.load_jpg_from_buffer(image)
		print("Loading Image")
		yield(get_tree(), "idle_frame")
		emit_signal("got_image", currentImage)
		
func _take_image():
	if imagePlugin:
		imagePlugin.getCameraImage()
	else:
		print("Plugin isnt loaded")
