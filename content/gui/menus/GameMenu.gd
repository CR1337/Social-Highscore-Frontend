extends Node2D

func _ready():
	pass # Replace with function body.


func _on_ContinueButton_pressed():
	ViewportManager.change_to_transparent()


func _on_ConfigButton_pressed():
	ViewportManager.configMenu.refresh()
	ViewportManager.change_to_config()


func _on_StartmenuButton_pressed():
	pass # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit()
