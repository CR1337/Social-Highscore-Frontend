extends Node2D


onready var tid_edit = $Background/Margin/VBox/TidTextEdit
onready var sig_edit = $Background/Margin/VBox/SigTextEdit
onready var money_spinbox = $Background/Margin/VBox/MoneyHBox/MoneySpinBox
onready var score_spinbox = $Background/Margin/VBox/ScoreHBox/ScoreSpinBox
onready var hunger_spinbox = $Background/Margin/VBox/HungerHBox/HungerSpinBox

func _update_debug_menu():
	money_spinbox.value = GameStateController.money
	score_spinbox.value = GameStateController.score
	hunger_spinbox.value = GameStateController.hunger

func _on_TriggerButton_pressed():
	EventBus.emit_signal("sig_trigger", tid_edit.text)


func _on_SignalButton_pressed():
	EventBus.emit_signal(sig_edit.text)


func _on_SkipWorkButton_pressed():
	EventBus.emit_signal("sig_trigger", 'tid_work_finished')


func _on_DayButton_pressed():
	GameStateController.story_controllers[GameStateController.current_day]._end_day()


func _on_MoneyButton_pressed():
	var amount = money_spinbox.value - GameStateController.money
	EventBus.emit_signal("sig_add_money", amount, "CHEATING")

func _on_ScoreButton_pressed():
	var amount = score_spinbox.value - GameStateController.score
	CitizenRecord.add_debug(amount)

func _on_HungerButton_pressed():
	GameStateController.hunger = hunger_spinbox.value
	print("Hunger: " + str(GameStateController.hunger))


func _on_BusticketButton_pressed():
	GameStateController.ticket_bought = true


func _on_BackButton_pressed():
	ViewportManager.change_to_transparent()


