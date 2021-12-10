extends Node2D

func _on_up_button_pressed():
	InputBus.emit_signal("up_pressed")


func _on_up_button_released():
	InputBus.emit_signal("up_released")


func _on_down_button_pressed():
	InputBus.emit_signal("down_pressed")


func _on_down_button_released():
	InputBus.emit_signal("down_released")


func _on_left_button_pressed():
	InputBus.emit_signal("left_pressed")


func _on_left_button_released():
	InputBus.emit_signal("left_released")


func _on_right_button_pressed():
	InputBus.emit_signal("right_pressed")


func _on_right_button_released():
	InputBus.emit_signal("right_released")


func _on_action_button_pressed():
	InputBus.emit_signal("action_pressed")


func _on_action_button_released():
	InputBus.emit_signal("action_released")


func _on_phone_button_pressed():
	InputBus.emit_signal("phone_pressed")
	var phoneMenu = preload("res://SmartphoneMenu.tscn").instance()
	add_child(phoneMenu)


func _on_phone_button_released():
	InputBus.emit_signal("phone_released")


func _on_menu_button_pressed():
	InputBus.emit_signal("menu_pressed")
	var gameMenu = preload("res://GameMenu.tscn").instance()
	add_child(gameMenu)


func _on_menu_button_released():
	InputBus.emit_signal("menu_pressed")
