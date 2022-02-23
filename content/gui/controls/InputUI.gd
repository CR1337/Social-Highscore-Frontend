extends Node2D

func _on_menu_button_pressed():
	InputBus.emit_signal("sig_menu_pressed")

func _on_UpButton_button_down():
	InputBus.emit_signal("sig_up_pressed")

func _on_UpButton_button_up():
	InputBus.emit_signal("sig_up_released")

func _on_DownButton_button_down():
	InputBus.emit_signal("sig_down_pressed")

func _on_DownButton_button_up():
	InputBus.emit_signal("sig_down_released")

func _on_LeftButton_button_down():
	InputBus.emit_signal("sig_left_pressed")

func _on_LeftButton_button_up():
	InputBus.emit_signal("sig_left_released")

func _on_RightButton_button_down():
	InputBus.emit_signal("sig_right_pressed")

func _on_RightButton_button_up():
	InputBus.emit_signal("sig_right_released")

func _on_ActionButton_button_down():
	InputBus.emit_signal("sig_action_pressed")

func _on_ActionButton_button_up():
	InputBus.emit_signal("sig_action_released")

func _on_PhoneButton_button_down():
	InputBus.emit_signal("sig_phone_pressed")

func _on_PhoneButton_button_up():
	InputBus.emit_signal("sig_phone_released")


func _on_DEBUGWorkFinishedButton_pressed():
	EventBus.emit_signal("sig_trigger", "tid_work_finished", {})
