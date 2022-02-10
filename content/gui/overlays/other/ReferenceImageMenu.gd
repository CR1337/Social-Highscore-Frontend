extends Node2D

var _image_processor_job_id: int
var _reference_image: Image

onready var _ok_button = $Background/Margin/VBox/OkButton
onready var _take_image_button = $Background/Margin/VBox/TakeImageButton
onready var _image_texture_rect = $Background/Margin/VBox/ImageTextureRect

func _ready():
	ImageProcessor.connect("sig_reference_image_taken", self, "_on_reference_image_taken")
	_ok_button.disabled = true

func set_reference_image(image):
	_reference_image = image
	_ok_button.disabled = false
	_display_image()

func _display_image():
	var tmp_texture = ImageTexture.new()
	tmp_texture.create_from_image(_reference_image, 0)
	_image_texture_rect.texture = tmp_texture
	_image_texture_rect.rect_rotation = Config.image_rotation_angle

func _on_TakeImageButton_pressed():
	_image_processor_job_id = ImageProcessor.take_reference_image()
	_take_image_button.disabled = true

func _on_TurnClockwiseButton_pressed():
	Config.image_rotation_angle -= 90
	if Config.image_rotation_angle < 0:
		Config.image_rotation_angle += 360
	_display_image()


func _on_TurnCounterclockwiseButton_pressed():
	Config.image_rotation_angle += 90
	if Config.image_rotation_angle >= 360:
		Config.image_rotation_angle -= 360
	_display_image()


func _on_OkButton_pressed():
	ViewportManager.config_menu.refresh()
	Config.store_to_file()
	ViewportManager.change_to_last()
	# ViewportManager.change_to_transparent()

func _on_reference_image_taken(image, job_id):
	if job_id != _image_processor_job_id:
		return
	_take_image_button.disabled = false
	_reference_image = image
	_display_image()
	_ok_button.disabled = false
