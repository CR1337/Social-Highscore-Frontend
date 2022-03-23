extends Node2D

onready var _buttons = [
	$Background/Margin/VBox/Slot0Button,
	$Background/Margin/VBox/Slot1Button,
	$Background/Margin/VBox/Slot2Button
]

func _ready():
	EventBus.connect("sig_fridge_content_changed", self, "_on_fridge_content_changed")


func _on_Slot0Button_pressed():
	GameStateController.eat_fridge_content(0)
	ViewportManager.change_to_transparent()
	
func _on_Slot1Button_pressed():
	GameStateController.eat_fridge_content(1)
	ViewportManager.change_to_transparent()

func _on_Slot2Button_pressed():
	GameStateController.eat_fridge_content(2)
	ViewportManager.change_to_transparent()

func _on_CloseButton_pressed():
	ViewportManager.change_to_transparent()

func _on_fridge_content_changed():
	for i in 3:
		_buttons[i].text = "<Empty>"
		_buttons[i].disabled = true
	for i in len(GameStateController.fridge_content):
		var food_item = GameStateController.fridge_content[i]
		_buttons[i].text = food_item['name']
		_buttons[i].disabled = false

