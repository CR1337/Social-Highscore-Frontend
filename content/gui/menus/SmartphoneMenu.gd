extends Node2D


func _on_NewsAppButton_pressed():
	pass # Replace with function body.


func _on_BankingAppButton_pressed():
	ViewportManager.change_to_banking_app()


func _on_MessengerAppButton_pressed():
	ViewportManager.change_to_messenger_contacts()


func _on_CitizenAppButton_pressed():
	pass # Replace with function body.


func _on_BackButton_pressed():
	ViewportManager.change_to_transparent()
