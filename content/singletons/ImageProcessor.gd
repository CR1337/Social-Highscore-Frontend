extends Node

enum JOB_TYPE {
	ANALYZE,
	VERIFY,
	REFERENCE_IMAGE,
	IDLE
}

var _http_request

var _busy = false
var _current_job_type = JOB_TYPE.IDLE
var _current_job_id: int = 0
var _next_job_id: int = 1

var _image_dict: Dictionary
var _raw_image_dict: Dictionary
var _b64_image_dict: Dictionary

signal sig_image_processing_done(parsed_response, job_id, image, raw_image, b64_image)
signal sig_image_processing_error(response_code)
signal sig_reference_image_taken(image, job_id)

var _b64_reference_image: String
var _reference_image: Image

func get_reference_image():
	return _reference_image

func _ready():
	NativeCameraController.connect("sig_got_image", self, "_on_got_image")
	_http_request = HTTPRequest.new()
	add_child(_http_request)
	_http_request.connect("request_completed", self, "_on_request_completed")

func take_reference_image():
	return _do_job(JOB_TYPE.REFERENCE_IMAGE)

func analyze():
	return _do_job(JOB_TYPE.ANALYZE)

func analyze_image(image, rawImage):
	if _busy:
		return null
	_busy = true
	_current_job_type = JOB_TYPE.ANALYZE
	_current_job_id = _next_job_id
	_next_job_id += 1
	call_deferred("_on_got_image", image, rawImage)
	return _current_job_id

func verify():
	return _do_job(JOB_TYPE.VERIFY)

func _do_job(job_type):
	if _busy:
		return null
	if _reference_image == null and job_type == JOB_TYPE.VERIFY:
		return null
	_busy = true
	_current_job_type = job_type
	_current_job_id = _next_job_id
	_next_job_id += 1
	NativeCameraController.take_image()
	return _current_job_id

func _on_got_image(image, rawImage):
	_busy = false
	var b64_image = "data:image/jpeg;base64," + Marshalls.raw_to_base64(rawImage)
	var endpoint
	var body
	var do_request = true

	match _current_job_type:
		JOB_TYPE.ANALYZE:
			endpoint = "analyze"
			body = {'img': b64_image, 'angle': Config.image_rotation_angle, 'job_id': _current_job_id}
		JOB_TYPE.VERIFY:
			endpoint = "verify"
			body = {'img0': b64_image, 'img1': _b64_reference_image, 'angle': Config.image_rotation_angle, 'job_id': _current_job_id}
		JOB_TYPE.REFERENCE_IMAGE:
			_reference_image = image
			_b64_reference_image = b64_image
			emit_signal("sig_reference_image_taken", image, _current_job_id)
			do_request = false

	if do_request:
		_image_dict[str(_current_job_id)] = image
		_b64_image_dict[str(_current_job_id)] = b64_image
		_raw_image_dict[str(_current_job_id)] = rawImage
		var url = "http://" + Config.server_address + ":" + Config.server_port + "/" + endpoint
		var error = _http_request.request(url, [], false, HTTPClient.METHOD_POST, JSON.print(body))
		if error != OK:
			print("Request Error!")
			EventBus.emit_signal("sig_debug_error", error)
			return
		else:
			EventBus.emit_signal("sig_debug_error", "Request OK")

	_current_job_type = JOB_TYPE.IDLE
	_current_job_id = -1

func _handle_response(response, body):
	var parsed_response = JSON.parse(body.get_string_from_utf8()).result
	var job_id = parsed_response['job_id']
	var image = _image_dict[str(job_id)]
	var raw_image = _raw_image_dict[str(job_id)]
	var b64_image = _b64_image_dict[str(job_id)]
	emit_signal("sig_image_processing_done", parsed_response, job_id, image, raw_image, b64_image)
	_image_dict.erase(str(job_id))
	_raw_image_dict.erase(str(job_id))
	_b64_image_dict.erase(str(job_id))
	return parsed_response

func _on_request_completed(result, response_code, headers, body):
	match response_code:
		200:
			_handle_response(result, body)
		400:
			var response = _handle_response(result, body)
			EventBus.emit_signal("sig_debug_error", response['error'])
		_:
			EventBus.emit_signal("sig_debug_error", str(response_code))
			emit_signal("sig_image_processing_error", response_code)

func persistent_state():
	return {
		"b64_reference_image": _b64_reference_image
	}

func restore_state(state):
	var saved_b64_reference_image = state["b64_reference_image"]
	if len(saved_b64_reference_image) == 0:
		return
	_b64_reference_image = saved_b64_reference_image
	var raw_reference_image = Marshalls.base64_to_raw(_b64_reference_image.split(",")[1])
	_reference_image = Image.new()
	_reference_image.load_jpg_from_buffer(raw_reference_image)
	ViewportManager.reference_image_menu.set_reference_image(_reference_image)
