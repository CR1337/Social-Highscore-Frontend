extends Node2D

func _process(delta):
	$Background/Label.text = TimeController.get_daytime()

func _on_NewsAppButton_pressed():
	ViewportManager.change_to_news_app_mainpage()


func _on_BankingAppButton_pressed():
	ViewportManager.change_to_banking_app()


func _on_MessengerAppButton_pressed():
	ViewportManager.change_to_messenger_contacts()


func _on_CitizenAppButton_pressed():
	ViewportManager.change_to_citizen_app()


func _on_BackButton_pressed():
	ViewportManager.change_to_transparent()
