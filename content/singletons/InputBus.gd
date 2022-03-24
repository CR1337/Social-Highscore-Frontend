extends Node

signal sig_up_pressed
signal sig_down_pressed
signal sig_left_pressed
signal sig_right_pressed

signal sig_up_released
signal sig_down_released
signal sig_left_released
signal sig_right_released

signal sig_action_pressed
signal sig_phone_pressed
signal sig_menu_pressed

signal sig_action_released
signal sig_phone_released
signal sig_menu_released

var direction: Vector2

func _ready():
	connect("sig_up_pressed", self, "_on_up_pressed")
	connect("sig_down_pressed", self, "_on_down_pressed")
	connect("sig_left_pressed", self, "_on_left_pressed")
	connect("sig_right_pressed", self, "_on_right_pressed")

	connect("sig_up_released", self, "_on_up_released")
	connect("sig_down_released", self, "_on_down_released")
	connect("sig_left_released", self, "_on_left_released")
	connect("sig_right_released", self, "_on_right_released")

func _on_up_pressed():
	direction = Vector2.UP

func _on_down_pressed():
	direction = Vector2.DOWN

func _on_left_pressed():
	direction = Vector2.LEFT

func _on_right_pressed():
	direction = Vector2.RIGHT

func _on_up_released():
	direction = Vector2.ZERO

func _on_down_released():
	direction = Vector2.ZERO

func _on_left_released():
	direction = Vector2.ZERO

func _on_right_released():
	direction = Vector2.ZERO

func _process(delta):
	if Input.is_key_pressed(KEY_S):
		_take_screenshot()


var _screenshot_counter = 0
const _screenshot_path = "user://screenshots/presentation"

func _take_screenshot():
	var image = get_viewport().get_texture().get_data()
	var path = _screenshot_path + str(_screenshot_counter) + ".png"
	image.flip_y()
	image.save_png(path)
	_screenshot_counter += 1
	return path
