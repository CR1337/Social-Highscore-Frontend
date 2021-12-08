extends Node

var dummy:PoolByteArray

var imagePlugin
signal got_image(image, rawImage)
func _ready():
	if Engine.has_singleton("GodotGetImage"):
		imagePlugin = Engine.get_singleton("GodotGetImage")
		imagePlugin.connect("image_request_completed", self, "_received_image") 

func _received_image(dict):
	EventBus.emit_signal("debug_error", dict)
	for image in dict.values():
		EventBus.emit_signal("debug_error", "Received Image")
		var currentImage = Image.new()
		currentImage.load_jpg_from_buffer(image)
		print("Loading Image")
		yield(get_tree(), "idle_frame")
		emit_signal("got_image", currentImage, image)
		
func take_image():
	if imagePlugin:
		EventBus.emit_signal("debug_error", "take_picture")
		imagePlugin.getCameraImage()
	else:
		EventBus.emit_signal("debug_error", "plugin not loaded")
		emit_signal("got_image", dummy)
