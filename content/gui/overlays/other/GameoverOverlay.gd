extends Node2D

onready var _text_label = $Background/Margin/VBox/TextLabel
onready var _button = $Background/Margin/VBox/Button

var _text_dict: Dictionary
const _text_dict_filename = "res://texts/gameover.json"

func _ready():
	_load_text_dict()

func _load_text_dict():
	var file = File.new()
	file.open(_text_dict_filename, file.READ)
	_text_dict = JSON.parse(
		file.get_as_text()
	).result
	file.close()

func prepare_gameover_overlay(gameover_reason):
	_text_label.text = _text_dict[gameover_reason]

func _on_Button_pressed():
	SaveGameController.delete_game()
	get_tree().quit()
