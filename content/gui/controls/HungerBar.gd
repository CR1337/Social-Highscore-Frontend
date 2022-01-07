extends ProgressBar

func _ready():
	GameStateController.connect("hunger_changed", self, "_on_hunger_changed")

func _on_hunger_changed(hunger):
	value = hunger
