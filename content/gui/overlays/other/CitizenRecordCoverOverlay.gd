extends Node2D

onready var _texture_rect = $Background/Margin/VBox/TextureRect

func show():
	var tmp_texture = ImageTexture.new()
	tmp_texture.create_from_image(ImageProcessor.get_reference_image(), 0)
	_texture_rect.texture = tmp_texture
	_texture_rect.rect_rotation = Config.image_rotation_angle

func _on_OpenButton_pressed():
	ViewportManager.change_to_citizen_record()
