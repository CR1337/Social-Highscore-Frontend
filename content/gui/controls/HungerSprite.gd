extends AnimatedSprite

func _ready():
	GameStateController.increase_hunger()
	GameStateController.increase_hunger()
	visible = false
	GameStateController.connect("sig_hunger_changed", self, "_on_hunger_changed")
	call_deferred("_handle_hunger", GameStateController.hunger)
	
func _handle_hunger(hunger):
	if hunger < 1:
		visible = false
	elif hunger == 1:
		visible = true
		animation = 'hungry'
	else:
		visible = true
		animation = 'very_hungry'
		
func _on_hunger_changed(hunger):
	_handle_hunger(hunger)
