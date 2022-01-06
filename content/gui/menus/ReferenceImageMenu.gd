extends Node2D

var image_processor_job_id: int
var reference_image: Image


# Called when the node enters the scene tree for the first time.
func _ready():
	ImageProcessor.connect("reference_image_taken", self, "_on_reference_image_taken")
	$Background/MarginContainer/VBoxContainer/OkButton.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _display_image():
	var tmp_texture = ImageTexture.new()
	tmp_texture.create_from_image(reference_image, 0)
	$Background/MarginContainer/VBoxContainer/ImageTextureRect.texture = tmp_texture
	$Background/MarginContainer/VBoxContainer/ImageTextureRect.rect_rotation = Config.imageRotationAngle

func _on_TakeImageButton_pressed():
	image_processor_job_id = ImageProcessor.take_reference_image()
	$Background/MarginContainer/VBoxContainer/TakeImageButton.disabled = true


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
	ViewportManager.change_to_transparent()
	
func _on_reference_image_taken(image, job_id):
	if job_id != image_processor_job_id:
		return
	$Background/MarginContainer/VBoxContainer/TakeImageButton.disabled = false
	reference_image = image 
	_display_image()
	$Background/MarginContainer/VBoxContainer/OkButton.disabled = false
