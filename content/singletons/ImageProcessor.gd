extends Node

enum JOB_TYPE {
	ANALYZE,
	VERIFY,
	REFERENCE_IMAGE,
	IDLE
}

var http_request

var busy = false
var current_job_type = JOB_TYPE.IDLE
var current_job_id = null
var next_job_id = 1

var image_dict: Dictionary

signal image_processing_done(response, job_id, image)
signal image_processing_error(response_code)

var b64_reference_image: String
var reference_image: Image

func _ready():
	NativeCameraController.connect("got_image", self, "_on_got_image")
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_request_completed")
	
func take_reference_image():
	return _do_job(JOB_TYPE.REFERENCE_IMAGE)
	
func analyze():
	return _do_job(JOB_TYPE.ANALYZE)
	
func verify():
	return _do_job(JOB_TYPE.VERIFY)
	
func _do_job(job_type):
	if busy:
		return null
	if reference_image == null and job_type == JOB_TYPE.VERIFY:
		return null
	busy = true
	current_job_type = job_type
	current_job_id = next_job_id
	next_job_id += 1
	NativeCameraController.take_image()
	return current_job_id

func _on_got_image(image, rawImage):
	print(rawImage.size())
	busy = false
	var b64_image = "data:image/jpeg;base64," + Marshalls.raw_to_base64(rawImage)
	var endpoint
	var body
	var do_request = true
	
	match current_job_type:
		JOB_TYPE.ANALYZE:
			endpoint = "analyze"
			body = {'img': b64_image, 'angle': Config.imageRotationAngle, 'job_id': current_job_id}
		JOB_TYPE.VERIFY:
			endpoint = "verify"
			body = {'img0': b64_image, 'img1': b64_reference_image, 'angle': Config.imageRotationAngle, 'job_id': current_job_id}
		JOB_TYPE.REFERENCE_IMAGE:
			reference_image = image
			b64_reference_image = b64_image
			do_request = false
			
	if do_request:
		image_dict[str(current_job_id)] = image
		var url = "http://" + Config.serverAddress + ":" + Config.serverPort + "/" + endpoint
		var error = http_request.request(url, [], false, HTTPClient.METHOD_POST, JSON.print(body))
		if error != OK:
			print("Request Error!")
			EventBus.emit_signal("debug_error", error)
			return
		else:
			EventBus.emit_signal("debug_error", "Request OK")
			
	current_job_type = JOB_TYPE.IDLE
	current_job_id = null
	
func _handle_response(response, body):
	var parsed_response = JSON.parse(body.get_string_from_utf8()).result
	var job_id = parsed_response['job_id']
	print(job_id)
	print(image_dict)
	var image = image_dict[str(job_id)]
	emit_signal("image_processing_done", parsed_response, job_id, image)
	image_dict.erase(job_id)
	return parsed_response
	
func _on_request_completed(result, response_code, headers, body):
	match response_code:
		200:
			_handle_response(result, body)
		400:
			var response = _handle_response(result, body)
			EventBus.emit_signal("debug_error", response['error'])
		_:
			EventBus.emit_signal("debug_error", str(response_code))
			emit_signal("image_processing_error", response_code)
			
