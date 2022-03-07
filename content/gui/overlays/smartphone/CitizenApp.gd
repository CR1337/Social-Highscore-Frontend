extends Node2D

onready var _score_label = $Background/Margin/VBox/HBox/ScoreLabel
onready var _record_label = $Background/Margin/VBox/RecordLabel
onready var _info_button = $Background/Margin/VBox/InfoButton
onready var _back_button = $Background/Margin/VBox/BackButton

const _info_text = """
⇨ Behave responsibly in public.
⇨ Live a healthy life.
⇨ Reflect our peoples values with your emotions, words and deeds.
⇨ Visit your parents frequently.
⇨ Work hard and honest.
⇨ Donate your blood frequently.
⇨ Donate your kindey to those in need.
⇨ Avoid enemies of the people and report them.
"""

func _ready():
	GameStateController.connect("sig_score_changed", self, "_on_score_changed")
	GameStateController.connect("sig_score_class_changed", self, "_on_score_class_changed")
	call_deferred("_DEBUG_add_records")

func _display_score():
	_score_label.text = str(GameStateController.score)

func _display_records():
	_record_label.clear()
	for record in CitizenRecord.records:
		var record_string = CitizenRecord.record_display_string_for_app(record)
		_record_label.append_bbcode("\n\n" + record_string)
		var color = 'green'
		if record['score'] == 0:
			continue
		elif record['score'] < 0:
			color = 'red'
		_record_label.append_bbcode("\n[color=" + color + "]" + str(record['score']) + "[/color]")
	_record_label.scroll_to_line(_record_label.get_line_count() - 1)

func _show_info():
	OS.alert(_info_text, "Good Citizen Guide")

func _on_score_changed(new_value):
	_display_score()
	_display_records()
	EventBus.emit_signal("sig_notification", 'score', "Your score has changed")

func _on_score_class_changed():
	_display_score()
	_display_records()
	TimeController.setTimer(2, self, "score_class_change")

func score_class_change(handle):
	EventBus.emit_signal("sig_notification", 'score', "Your score class has changed")

func _on_InfoButton_pressed():
	_show_info()

func _on_BackButton_pressed():
	ViewportManager.change_to_smartphone()


