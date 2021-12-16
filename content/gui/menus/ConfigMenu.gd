extends Node2D

onready var addressLineEdit = $Background/MarginContainer/VBoxContainer/AddressVBoxContainer/AddressLineEdit
onready var portLineEdit = $Background/MarginContainer/VBoxContainer/PortVBoxContainer/PortLineEdit
onready var okButton = $Background/MarginContainer/VBoxContainer/ButtonsHBoxContainer/OkButton

onready var CheckBox0 = $Background/MarginContainer/VBoxContainer/AngleVBoxContainer/HBoxContainer/CheckBox0
onready var CheckBox90 = $Background/MarginContainer/VBoxContainer/AngleVBoxContainer/HBoxContainer/CheckBox90
onready var CheckBox180 = $Background/MarginContainer/VBoxContainer/AngleVBoxContainer/HBoxContainer/CheckBox180
onready var CheckBox270 = $Background/MarginContainer/VBoxContainer/AngleVBoxContainer/HBoxContainer/CheckBox270

onready var CheckBoxes = [
	$Background/MarginContainer/VBoxContainer/AngleVBoxContainer/HBoxContainer/CheckBox0,
	$Background/MarginContainer/VBoxContainer/AngleVBoxContainer/HBoxContainer/CheckBox90,
	$Background/MarginContainer/VBoxContainer/AngleVBoxContainer/HBoxContainer/CheckBox180,
	$Background/MarginContainer/VBoxContainer/AngleVBoxContainer/HBoxContainer/CheckBox270
]

func _ready():
	pass
	
func _set_selected_angle(angle):
	var index = angle / 90
	for checkBox in CheckBoxes:
		checkBox.pressed = false
	CheckBoxes[index].pressed = true
	
func _get_selected_angle():
	if CheckBoxes[0].pressed:
		return 0
	elif CheckBoxes[1].pressed:
		return 90
	elif CheckBoxes[2].pressed:
		return 180
	elif CheckBoxes[3].pressed:
		return 270

func refresh():
	Config.load_from_file()
	addressLineEdit.text = Config.serverAddress
	portLineEdit.text = Config.serverPort
	_set_selected_angle(Config.imageRotationAngle)

func _on_OkButton_pressed():
	Config.serverAddress = addressLineEdit.text
	Config.serverPort = portLineEdit.text
	Config.imageRotationAngle = _get_selected_angle()
	Config.store_to_file()
	ViewportManager.change_to_last()
	
func _on_CancelButton_pressed():
	ViewportManager.change_to_last()


func _port_is_valid():
	portLineEdit.set("custom_colors/font_color", Color(1,1,1))
	okButton.disabled = false
	
func _port_is_invalid():
	portLineEdit.set("custom_colors/font_color", Color(1,0,0))
	okButton.disabled = true

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