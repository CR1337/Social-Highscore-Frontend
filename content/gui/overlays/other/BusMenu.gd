extends Node2D


#onready var addressLineEdit = $Background/MarginContainer/VBoxContainer/AddressVBoxContainer/AddressLineEdit
#onready var portLineEdit = $Background/MarginContainer/VBoxContainer/PortVBoxContainer/PortLineEdit
#onready var okButton = $Background/MarginContainer/VBoxContainer/ButtonsHBoxContainer/OkButton

export (NodePath) var leave_city_area_path
export (Vector2) var leave_city_player_position

export (NodePath) var leave_living_area_path
export (Vector2) var leave_living_player_position

export (NodePath) var leave_utility_area_path
export (Vector2) var leave_utility_player_position

func _ready():
	pass

func _on_LivingButton_pressed():
	ViewportManager.change_area(get_node(leave_living_area_path), leave_living_player_position)
	ViewportManager.change_to_transparent()


func _on_CityButton_pressed():
	ViewportManager.change_area(get_node(leave_city_area_path), leave_city_player_position)
	ViewportManager.change_to_transparent()


func _on_UtilityButton_pressed():
	ViewportManager.change_area(get_node(leave_utility_area_path), leave_utility_player_position)
	ViewportManager.change_to_transparent()


func _on_BackButton_pressed():
	ViewportManager.change_to_transparent()
