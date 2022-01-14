extends Node2D

var image_processor_job_id: int
var reference_image: Image

onready var ok_button = $Background/MarginContainer/VBoxContainer/OkButton
onready var take_image_button = $Background/MarginContainer/VBoxContainer/TakeImageButton
onready var image_texture_rect = $Background/MarginContainer/VBoxContainer/ImageTextureRect

func _ready():
	ImageProcessor.connect("reference_image_taken", self, "_on_reference_image_taken")
	ok_button.disabled = true
	
func set_reference_image(image):
	reference_image = image
	ok_button.disabled = false
	_display_image()

func _display_image():
	var tmp_texture = ImageTexture.new()
	tmp_texture.create_from_image(reference_image, 0)
	image_texture_rect.texture = tmp_texture
	image_texture_rect.rect_rotation = Config.imageRotationAngle

func _on_TakeImageButton_pressed():
	image_processor_job_id = ImageProcessor.take_reference_image()
	take_image_button.disabled = true

func _on_TurnClockwiseButton_pressed():
	Config.imageRotationAngle -= 90
	if Config.imageRotationAngle < 0:
		Config.imageRotationAngle += 360
	_display_image()


func _on_TurnCounterclockwiseButton_pressed():
	Config.imageRotationAngle += 90
	if Config.imageRotationAngle >= 360:
		Config.imageRotationAngle -= 360
	_display_image()


func _on_OkButton_pressed():
	ViewportManager.configMenu.refresh()
	Config.store_to_file()
	ViewportManager.change_to_transparent()
	
func _on_reference_image_taken(image, job_id):
	if job_id != image_processor_job_id:
		return
	take_image_button.disabled = false
	reference_image = image 
	_display_image()
	ok_button.disabled = false
