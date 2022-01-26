extends Node2D

onready var _score_label = $Background/MarginContainer/VBoxContainer/HBoxContainer/ScoreLabel
onready var _record_label = $Background/MarginContainer/VBoxContainer/RecordLabel
onready var _info_button = $Background/MarginContainer/VBoxContainer/InfoButton
onready var _back_button = $Background/MarginContainer/VBoxContainer/BackButton

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
	call_deferred("_DEBUG_add_records")
	
func _display_score():
	_score_label.text = str(GameStateController.score)
	
func _display_records():
	print("Records:\n" + str(CitizenRecord.records))
	_record_label.clear()
	for record in CitizenRecord.records:
		var record_string = CitizenRecord.record_display_string_for_app(record)
		_record_label.append_bbcode("\n\n" + record_string)
		var color = 'green'
		if record['score'] < 0:
			color = 'red'
		_record_label.append_bbcode("\n[color=" + color + "]" + str(record['score']) + "[/color]")
	_record_label.scroll_to_line(_record_label.get_line_count() - 1)
	
func _show_info():
	OS.alert(_info_text, "Good Citizen Guide")
	
func _on_score_changed(new_value):
	print("_on_score_changed: ", new_value)
	_display_score()
	_display_records()
	
func _on_InfoButton_pressed():
	_show_info()

func _on_BackButton_pressed():
	ViewportManager.change_to_smartphone()
	
func _DEBUG_add_records():
	print("_DEBUG_add_records: add_unhealthy_food_at_home(-15, 'ice cream')")
	CitizenRecord.add_unhealthy_food_at_home(-15, 'ice cream')
	GameStateController.change_score(-15)
	
	print("_DEBUG_add_records: add_blood_donation(50)")
	CitizenRecord.add_blood_donation(50)
	GameStateController.change_score(50)
	
	print("_DEBUG_add_records: aadd_refused_reaction_on_news(-15, 'The economy is good', 'happy')")
	CitizenRecord.add_refused_reaction_on_news(-40, 'The economy is good', 'happy')
	GameStateController.change_score(-40)
	
