extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum JOB_TYPE {
	ANALYZE,
	AUTHENTICATE,
	ANALYZE_AND_AUTHENTICATE
}

var job_queue: Array
var request_queue: Array

var base_url = "http://78.47.102.251:80/"
# var base_url = "http://127.0.0.1:5000/"
# var base_url = "http://192.168.0.135:5000/"
var http_request

signal image_processing_done(response, handle, image)

# Called when the node enters the scene tree for the first time.
func _ready():
	NativeCameraController.connect("got_image", self, "_got_image")
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_request_completed")
	
func analyze(handle):
	job_queue.push_front([JOB_TYPE.ANALYZE, handle])
	NativeCameraController.take_image()
	
func authenticate(handle):
	job_queue.push_front([JOB_TYPE.AUTHENTICATE, handle])
	NativeCameraController.take_image()
	
func analyze_and_authenticate(handle):
	job_queue.push_front([JOB_TYPE.ANALYZE_AND_AUTHENTICATE, handle])
	NativeCameraController.take_image()

func _got_image(image, rawImage):
	var job_type_and_handle = job_queue.pop_back()
	var endpoint
	var b64_image = "data:image/jpeg;base64," + Marshalls.raw_to_base64(rawImage)
	var body
	# TODO: Server also needs handle
	match job_type_and_handle[0]:
		JOB_TYPE.ANALYZE:
			endpoint = "analyze"
			body = {'img': b64_image, 'angle': 90}
		JOB_TYPE.AUTHENTICATE:
			endpoint = "authenticate"
			body = {}
			# TODO: haw to handle the reference image?
		JOB_TYPE.ANALYZE_AND_AUTHENTICATE:
			endpoint = "analyze_and_authenticate"
			body = {}
	EventBus.emit_signal("debug_error", "Now request")	
	var error = http_request.request(base_url + endpoint, [], false, HTTPClient.METHOD_POST, JSON.print(body))
	print("BODY: ", to_json(body))
	if error != OK:
		print("Request Error!")
		EventBus.emit_signal("debug_error", error)
		return
	else:
		EventBus.emit_signal("debug_error", "Request OK")
	request_queue.push_front([job_type_and_handle[0], job_type_and_handle[1], image])
	
			
func _on_request_completed(result, response_code, headers, body):
	EventBus.emit_signal("debug_error", "Request completed")
	var job_type_handle_and_image = request_queue.pop_back()
	if response_code != 200:
		print("Response Error:", str(response_code))
		return
	elif result != HTTPRequest.RESULT_SUCCESS:
		print("Result Error:", str(result))
		return
	var response = JSON.parse(body.get_string_from_utf8())
	emit_signal("image_processing_done", response, job_type_handle_and_image[1], job_type_handle_and_image[2])	
			
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
