extends Node2D


#onready var addressLineEdit = $Background/MarginContainer/VBoxContainer/AddressVBoxContainer/AddressLineEdit
#onready var portLineEdit = $Background/MarginContainer/VBoxContainer/PortVBoxContainer/PortLineEdit
#onready var okButton = $Background/MarginContainer/VBoxContainer/ButtonsHBoxContainer/OkButton

export (NodePath) var leaveCityAreaPath
export (Vector2) var leaveCityPlayerPosition

export (NodePath) var leaveLivingAreaPath
export (Vector2) var leaveLivingPlayerPosition

export (NodePath) var leaveUtilityAreaPath
export (Vector2) var leaveUtilityPlayerPosition

func _ready():
	pass

func _on_LivingButton_pressed():
	ViewportManager.change_area(get_node(leaveLivingAreaPath), leaveLivingPlayerPosition)
	ViewportManager.change_to_transparent()


func _on_CityButton_pressed():
	ViewportManager.change_area(get_node(leaveCityAreaPath), leaveCityPlayerPosition)
	ViewportManager.change_to_transparent()


func _on_UtilityButton_pressed():
	ViewportManager.change_area(get_node(leaveUtilityAreaPath), leaveUtilityPlayerPosition)
	ViewportManager.change_to_transparent()


func _on_BackButton_pressed():
	ViewportManager.change_to_transparent()
