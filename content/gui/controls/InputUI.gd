extends Node2D

func _on_menu_button_pressed():
	InputBus.emit_signal("sig_menu_pressed")
	

func _on_DEBUGMenuButton_pressed():
	ViewportManager.change_to_debug()


func _on_WhatNextButton_pressed():
	EventBus.emit_signal("sig_what_next")


func _on_UpButton_pressed():
	InputBus.emit_signal("sig_up_pressed")


func _on_UpButton_released():
	InputBus.emit_signal("sig_up_released")
	

func _on_DownButton_pressed():
	InputBus.emit_signal("sig_down_pressed")


func _on_DownButton_released():
	InputBus.emit_signal("sig_down_released")


func _on_LeftButton_pressed():
	InputBus.emit_signal("sig_left_pressed")


func _on_LeftButton_released():
	InputBus.emit_signal("sig_left_released")
	

func _on_RightButton_pressed():
	InputBus.emit_signal("sig_right_pressed")


func _on_RightButton_released():
	InputBus.emit_signal("sig_right_released")


func _on_ActionButton_pressed():
	InputBus.emit_signal("sig_action_pressed")
	

func _on_ActionButton_released():
	InputBus.emit_signal("sig_action_released")


func _on_PhoneButton_pressed():
	InputBus.emit_signal("sig_phone_pressed")


func _on_PhoneButton_released():
	InputBus.emit_signal("sig_phone_released")
