extends Node2D

var image_processor_job_id
var post_authentication_trigger: Node


func _ready():
	ImageProcessor.connect("image_processing_done", self, "_on_image_processing_done")

func _on_TakeImageButton_pressed():
	$Background/MarginContainer/VBoxContainer/HBoxContainer/CancelButton.disabled = true
	$Background/MarginContainer/VBoxContainer/HBoxContainer/TakeImageButton.disabled = true
	$Background/MarginContainer/VBoxContainer/Label.text = "Verifying face. Please wait..."
	image_processor_job_id = ImageProcessor.verify()
	
func _on_image_processing_done(parsed_response, job_id, image):
	if image_processor_job_id != job_id:
		return
	$Background/MarginContainer/VBoxContainer/HBoxContainer/CancelButton.disabled = false
	$Background/MarginContainer/VBoxContainer/HBoxContainer/TakeImageButton.disabled = false
	if parsed_response['verified']:
		ViewportManager.change_to_transparent()
		post_authentication_trigger.trigger()
		$Background/MarginContainer/VBoxContainer/Label.text = "Please take a picture of your face."
		CitizenRecord.await_analyze_response(
			ImageProcessor.analyze_image(image)
		)
	else:
		$Background/MarginContainer/VBoxContainer/Label.text = "Verfication failed. Please try again."

func _on_CancelButton_pressed():
	ViewportManager.change_to_transparent()
