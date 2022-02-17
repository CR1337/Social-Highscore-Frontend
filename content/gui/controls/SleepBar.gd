extends ProgressBar

func _ready():
	GameStateController.connect("sig_sleep_changed", self, "_on_sleep_changed")

func _on_sleep_changed(sleep):
	value = sleep
