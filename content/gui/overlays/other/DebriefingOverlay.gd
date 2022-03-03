extends Node2D

onready var _text_label = $Background/Margin/VBox/TextLabel

func show_debriefing():
	# TODO: Show all relevant scores
	var text = "Let's view your performance:\n"
	
	text += "Number of correct decisions: " + str(MinigameController.t_p_counter + MinigameController.t_n_counter) + "\n"
	text += "Number of incorrect decisions: " + str(MinigameController.f_p_counter + MinigameController.f_n_counter) + "\n"

	text += "Your loan for today: " + str(MinigameController.loan())
	
	_text_label.bbcode_text = ""
	_text_label.append_bbcode(text)

func _on_EndButton_pressed():
	EventBus.emit_signal("sig_trigger", "tid_work_finished")
	ViewportManager.change_to_transparent()
