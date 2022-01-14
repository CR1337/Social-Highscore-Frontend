extends Node2D

var image_processor_job_id
var post_authentication_trigger_id: String

onready var cancel_button = $Background/MarginContainer/VBoxContainer/HBoxContainer/CancelButton
onready var take_image_button = $Background/MarginContainer/VBoxContainer/HBoxContainer/TakeImageButton
onready var label = $Background/MarginContainer/VBoxContainer/Label


func _ready():
	ImageProcessor.connect("image_processing_done", self, "_on_image_processing_done")

func _on_TakeImageButton_pressed():
	cancel_button.disabled = true
	take_image_button.disabled = true
	label.text = "Verifying face. Please wait..."
	image_processor_job_id = ImageProcessor.verify()
	
func _on_image_processing_done(parsed_response, job_id, image, rawImage):
	if image_processor_job_id != job_id:
		return
	cancel_button.disabled = false
	take_image_button.disabled = false
	if parsed_response.get('error', 'none') == 'no face':
		label.text = "Verfication failed. Please try again."
	elif parsed_response['verified']:
		_exit_overlay()
		EventBus.emit_signal("trigger", post_authentication_trigger_id)
		CitizenRecord.await_analyze_response(
			ImageProcessor.analyze_image(image, rawImage)
		)
	else:
		label.text = "Verfication failed. Please try again."

func _on_CancelButton_pressed():
	_exit_overlay()
	
func _exit_overlay():
	ViewportManager.change_to_transparent()
	label.text = "Please take a picture of your face."
