extends Node2D

signal up_pressed
signal up_released
signal down_pressed
signal down_released
signal left_pressed
signal left_released
signal right_pressed
signal right_released
signal action_pressed
signal action_released


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_up_button_pressed():
	emit_signal("up_pressed")


func _on_up_button_released():
	emit_signal("up_released")


func _on_down_button_pressed():
	emit_signal("down_pressed")


func _on_down_button_released():
	emit_signal("down_released")


func _on_left_button_pressed():
	emit_signal("left_pressed")


func _on_left_button_released():
	emit_signal("left_released")


func _on_right_button_pressed():
	emit_signal("right_pressed")


func _on_right_button_released():
	emit_signal("right_released")


func _on_action_button_pressed():
	emit_signal("action_pressed")


func _on_action_button_released():
	emit_signal("action_released")


func _on_phone_button_pressed():
	var phoneMenu = preload("res://SmartphoneMenu.tscn").instance()
	add_child(phoneMenu)


func _on_phone_button_released():
	pass # Replace with function body.


func _on_menu_button_pressed():
	var gameMenu = preload("res://GameMenu.tscn").instance()
	add_child(gameMenu)
