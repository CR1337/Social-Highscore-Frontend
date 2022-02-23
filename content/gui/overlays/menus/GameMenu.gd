extends Node2D

onready var dialog = $CanvasLayer/ConfirmationDialog

func _on_ContinueButton_pressed():
	ViewportManager.change_to_transparent()


func _on_ConfigButton_pressed():
	ViewportManager.config_menu.load_and_refresh()
	ViewportManager.change_to_config()


func _on_QuitButton_pressed():
	ViewportManager.change_to_transparent()
	SaveGameController.save_game()
	get_tree().quit()


func _on_NewGameButton_pressed():
	dialog.popup_centered_clamped()
	
func _on_ConfirmationDialog_confirmed():
	SaveGameController.delete_game()
	SaveGameController.load_default_game()


func _on_DebugCitizenRecordButton_pressed():
	ViewportManager.change_to_citizen_record_overlay()




