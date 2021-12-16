extends Node2D

onready var addressLineEdit = $Background/MarginContainer/VBoxContainer/AddressVBoxContainer/AddressLineEdit
onready var portLineEdit = $Background/MarginContainer/VBoxContainer/PortVBoxContainer/PortLineEdit
onready var angleOptionButton = $Background/MarginContainer/VBoxContainer/AngleVBoxContainer/AngleOptionButton
onready var okButton = $Background/MarginContainer/VBoxContainer/ButtonsHBoxContainer/OkButton

func _ready():
	pass

func refresh():
	Config.load_from_file()
	addressLineEdit.text = Config.serverAddress
	portLineEdit.text = Config.serverPort
	angleOptionButton.text = str(Config.imageRotationAngle)

func _on_OkButton_pressed():
	Config.serverAddress = addressLineEdit.text
	Config.serverPort = portLineEdit.text
	Config.imageRotationAngle = int(angleOptionButton.text)
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



