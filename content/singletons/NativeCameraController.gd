extends Node

# FOR DEBUGGING ONLY:
var _debug_image: Image
var _raw_debug_image: PoolByteArray

var _image_plugin
signal sig_got_image(image, rawImage)

func _ready():
	OS.request_permissions()

	if Engine.has_singleton("GodotGetImage"):
		_image_plugin = Engine.get_singleton("GodotGetImage")
		_image_plugin.connect("image_request_completed", self, "_received_image")

	# FOR DEBUGGING ONLY:
	_raw_debug_image = Marshalls.base64_to_raw(Debug.b64_debug_image)
	_debug_image = Image.new()
	_debug_image.load_jpg_from_buffer(_raw_debug_image)

func _received_image(dict):
	EventBus.emit_signal("sig_debug_error", dict)
	for image in dict.values():
		EventBus.emit_signal("sig_debug_error", "Received Image")
		var currentImage = Image.new()
		currentImage.load_jpg_from_buffer(image)
		print("Loading Image")
		yield(get_tree(), "idle_frame")
		emit_signal("sig_got_image", currentImage, image)

func take_image():
	if _image_plugin:
		EventBus.emit_signal("sig_debug_error", "take_picture")
		_image_plugin.getCameraImage()
	else:
		EventBus.emit_signal("sig_debug_error", "plugin not loaded")
		call_deferred("emit_signal", "sig_got_image", _debug_image, _raw_debug_image)
