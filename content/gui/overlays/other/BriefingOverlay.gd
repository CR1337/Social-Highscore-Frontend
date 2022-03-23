extends Node2D

onready var _text_label = $Background/Margin/VBox/TextLabel
onready var _tutorial_texture_rect = $Background/Margin/VBox/TextureRect
onready var _yes_button = $Background/Margin/VBox/HBox/YesButton
onready var _no_button = $Background/Margin/VBox/HBox/NoButton

onready var _filename = "res://texts/briefings.json"

var _text_dict: Dictionary

func _load_text_dict():
	var file = File.new()
	file.open(_filename, file.READ)
	_text_dict = JSON.parse(
		file.get_as_text()
	).result
	file.close()

func _ready():
	_load_text_dict()

func start_briefing(state):
	_text_label.bbcode_text = ""
	_text_label.append_bbcode(_text_dict[str(state)])
	_load_tutorial_picture(str(state))

func _load_tutorial_picture(filename):
	# TODO: add briefing pictures:
	pass
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load("res://assets/briefing/" + filename + ".png")
	texture.create_from_image(image)
	_tutorial_texture_rect.texture = texture

func _start_work():
	MinigameController.start()

func _on_YesButton_pressed():
	_start_work()

func _on_NoButton_pressed():
	ViewportManager.change_to_transparent()
