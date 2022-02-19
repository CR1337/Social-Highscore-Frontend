extends Node2D

var _image_processor_job_id
var post_authentication_trigger_id: String

onready var _cancel_button = $Background/Margin/VBox/HBox/CancelButton
onready var _take_image_button = $Background/Margin/VBox/HBox/TakeImageButton
onready var _label = $Background/Margin/VBox/Label


func _ready():
	ImageProcessor.connect("sig_image_processing_done", self, "_on_image_processing_done")

func _on_TakeImageButton_pressed():
	_cancel_button.disabled = true
	_take_image_button.disabled = true
	_label.text = "Verifying face. Please wait..."
	_image_processor_job_id = ImageProcessor.verify()

func _on_image_processing_done(parsed_response, job_id, image, rawImage, b64_image):
	if _image_processor_job_id != job_id:
		return
	_cancel_button.disabled = false
	_take_image_button.disabled = false
	if parsed_response.get('error', 'none') == 'no face':
		_label.text = "Verfication failed. Please try again."
		EventBus.emit_signal("sig_trigger", post_authentication_trigger_id, {'success': false})
	elif parsed_response['verified']:
		_exit_overlay()
		EventBus.emit_signal("sig_trigger", post_authentication_trigger_id, {'success': true})
		CitizenRecord.await_analyze_response(
			ImageProcessor.analyze_image(image, rawImage)
		)
	else:
		_label.text = "Verfication failed. Please try again."
		EventBus.emit_signal("sig_trigger", post_authentication_trigger_id, {'success': false})

func _on_CancelButton_pressed():
	_exit_overlay()

func _exit_overlay():
	ViewportManager.change_to_transparent()
	_label.text = "Please take a picture of your face."
	EventBus.emit_signal("sig_trigger", post_authentication_trigger_id, {'success': false})
