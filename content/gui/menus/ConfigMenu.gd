extends Node2D

onready var _address_line_edit = $Background/Margin/VBox/AddressVBox/AddressLineEdit
onready var _port_line_edit = $Background/Margin/VBox/PortVBox/PortLineEdit
onready var _ok_button = $Background/Margin/VBox/ButtonsHBox/OkButton

onready var _check_boxes = [
	$Background/Margin/VBox/AngleVBox/HBox/CheckBox0,
	$Background/Margin/VBox/AngleVBox/HBox/CheckBox90,
	$Background/Margin/VBox/AngleVBox/HBox/CheckBox180,
	$Background/Margin/VBox/AngleVBox/HBox/CheckBox270
]

func _ready():
	pass

func _set_selected_angle(angle):
	var index = angle / 90
	for checkBox in _check_boxes:
		checkBox.pressed = false
	_check_boxes[index].pressed = true

func _get_selected_angle():
	if _check_boxes[0].pressed:
		return 0
	elif _check_boxes[1].pressed:
		return 90
	elif _check_boxes[2].pressed:
		return 180
	elif _check_boxes[3].pressed:
		return 270

func load_and_refresh():
	Config.load_from_file()
	refresh()

func refresh():
	_address_line_edit.text = Config.server_address
	_port_line_edit.text = Config.server_port
	_set_selected_angle(Config.image_rotation_angle)

func _on_OkButton_pressed():
	Config.server_address = _address_line_edit.text
	Config.server_port = _port_line_edit.text
	Config.image_rotation_angle = _get_selected_angle()
	Config.store_to_file()
	ViewportManager.change_to_last()

func _on_CancelButton_pressed():
	ViewportManager.change_to_last()


func _port_is_valid():
	_port_line_edit.set("custom_colors/font_color", Color(1,1,1))
	_ok_button.disabled = false

func _port_is_invalid():
	_port_line_edit.set("custom_colors/font_color", Color(1,0,0))
	_ok_button.disabled = true

func _on_PortLineEdit_text_changed(new_text):
	if not new_text.is_valid_integer():
		_port_is_invalid()
		return

	var port = int(new_text)
	if port < 0 or port > 65535:
		_port_is_invalid()
		return

	_port_is_valid()



func _on_CheckBox0_pressed():
	_set_selected_angle(0)


func _on_CheckBox90_pressed():
	_set_selected_angle(90)


func _on_CheckBox180_pressed():
	_set_selected_angle(180)


func _on_CheckBox270_pressed():
	_set_selected_angle(270)


func _on_TakeReferenceImageButton_pressed():
	ViewportManager.change_to_refenreceImage()
