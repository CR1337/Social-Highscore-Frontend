extends Label

func _ready():
	EventBus.connect("debug_error", self, "_on_debug_error")

func _on_debug_error(error):
	text = str(error)
