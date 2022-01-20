extends Node2D


func _process(delta):
	$Label.text = TimeController.get_daytime()

func _on_menu_button_pressed():
	InputBus.emit_signal("menu_pressed")

func _on_UpButton_button_down():
	InputBus.emit_signal("up_pressed")

func _on_UpButton_button_up():
	InputBus.emit_signal("up_released")

func _on_DownButton_button_down():
	InputBus.emit_signal("down_pressed")

func _on_DownButton_button_up():
	InputBus.emit_signal("down_released")
	
func _on_LeftButton_button_down():
	InputBus.emit_signal("left_pressed")

func _on_LeftButton_button_up():
	InputBus.emit_signal("left_released")

func _on_RightButton_button_down():
	InputBus.emit_signal("right_pressed")

func _on_RightButton_button_up():
	InputBus.emit_signal("right_released")

func _on_ActionButton_button_down():
	InputBus.emit_signal("action_pressed")

func _on_ActionButton_button_up():
	InputBus.emit_signal("action_released")

func _on_PhoneButton_button_down():
	InputBus.emit_signal("phone_pressed")


func _on_PhoneButton_button_up():
	InputBus.emit_signal("phone_released")
