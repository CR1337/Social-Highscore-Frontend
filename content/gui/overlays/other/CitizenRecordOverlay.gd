extends Node2D

onready var _box_container = $Background/Margin/HBox/ScrollContainer/VBox

func _ready():
	call_deferred("display_records")

func _clear():
	for child in _box_container.get_children():
		child.queue_free()

func display_records():
	_clear()
	for record in CitizenRecord.records:
		call("_display_" + record['type'], record)

func _create_label():
	var label = RichTextLabel.new()
	var dynamic_font = DynamicFont.new()
	dynamic_font = load("assets/fonts/Consolas.tres")
	label.set("custom_fonts/normal_font", dynamic_font)
	label.set("custom_colors/default_color", Color(1, 1, 1, 1))
	return label

func _create_big_label():
	var label = _create_label()
	label.rect_min_size = Vector2(688, 216)
	return label

func _create_small_label():
	var label = _create_label()
	label.rect_min_size = Vector2(452, 216)
	return label

func _create_texture(image_path):
	var textureRect = TextureRect.new()
	textureRect.rect_min_size = Vector2(216, 216)
	textureRect.rect_size = Vector2(216, 216)
	textureRect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	textureRect.expand = true

	var image = Image.new()
	image.load(image_path)
	

	var tmp_texture = ImageTexture.new()
	tmp_texture.create_from_image(image)
	textureRect.texture = tmp_texture
	textureRect.rect_rotation = Config.image_rotation_angle
	return textureRect

func _create_background():
	var new_background = ColorRect.new()
	new_background.rect_min_size = Vector2(728, 256)
	new_background.color = Color(0.5, 0.5, 0.5, 0.7)
	return new_background

func _create_record():
	var new_record = HBoxContainer.new()
	new_record.rect_size = Vector2(728, 256)
	new_record.alignment = BoxContainer.ALIGN_CENTER
	new_record.set("custom_constants/separation", 20)
	new_record.margin_left = 20
	new_record.margin_top = 20
	new_record.margin_bottom = 236
	new_record.margin_right = 708

	return new_record

func _emotion_string(preferred_emotions):
	if len(preferred_emotions) == 1:
		return preferred_emotions[0]
	elif len(preferred_emotions) == 2:
		return preferred_emotions[0] + " and " + preferred_emotions[1]
	else:
		return preferred_emotions[0] + ", " + _emotion_string(
			preferred_emotions.slice(1, len(preferred_emotions) - 1)
		)

func _display_record(record):
	match record['type']:
		_:
			var label = _create_label()
			label.rect_min_size = Vector2(728, 64)
			label.append_bbcode(record['type'])
			_box_container.add_child(label)

func _display_debug(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_big_label()
	var text = "The target has cheated.".format(
		{}
	)
	label.append_bbcode(text)
	new_background.add_child(new_record)
	new_record.add_child(label)
	_box_container.add_child(new_background)

func _display_score_class_changed(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_big_label()
	var text = "The target's score class changed to Class {class}.".format(
		{"class": record["new_class"]}
	)
	label.append_bbcode(text)
	new_background.add_child(new_record)
	new_record.add_child(label)
	_box_container.add_child(new_background)

func _display_no_job(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_big_label()
	var text = "The target has no job.".format(
		{}
	)
	label.append_bbcode(text)
	new_background.add_child(new_record)
	new_record.add_child(label)
	_box_container.add_child(new_background)

func _display_good_emotional_reaction_on_news(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_small_label()
	var text = "The target reacted to the news {news} with {emo} as intended by the government".format(
		{"news": record["news"],
		"emo": record["emotion"]}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)
	var image_texture_rect = _create_texture(record['face'])

	new_background.add_child(new_record)
	new_record.add_child(label)
	new_record.add_child(image_texture_rect)
	_box_container.add_child(new_background)

func _display_bad_emotional_reaction_on_news(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_small_label()
	var text = "The target reacted to the news {news} with {emo}, which was not accepted by the government.The government intended {pref_emo}".format(
		{"news": record["news"],
		"emo": record["emotion"],
		"pref_emo": _emotion_string(record['preferred_emotions'])}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)
	var image_texture_rect = _create_texture(record['face'])

	new_background.add_child(new_record)
	new_record.add_child(label)
	new_record.add_child(image_texture_rect)
	_box_container.add_child(new_background)

func _display_neutral_emotional_reaction_on_news(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_small_label()
	var text = "The target reacted to the news {news} with {emo},while the government intended {pref_emo}".format(
		{"news": record["news"],
		"emo": record["emotion"],
		"pref_emo": _emotion_string(record['preferred_emotions'])}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)
	var image_texture_rect = _create_texture(record['face'])

	new_background.add_child(new_record)
	new_record.add_child(label)
	new_record.add_child(image_texture_rect)
	_box_container.add_child(new_background)

func _display_refused_reaction_on_news(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_big_label()
	var text = "The target refused to share his reaction on the news {news}. The emotions {pref_emo} were intended.".format(
		{"news": record["news"],
		"pref_emo": _emotion_string(record['preferred_emotions'])}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)
	label.append_bbcode(text)
	new_background.add_child(new_record)
	new_record.add_child(label)
	_box_container.add_child(new_background)

func _display_good_emotional_reaction_at_authentication(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_small_label()
	var text = "The target was authenticated at {place} with {emo}, and showed one of the daily preferred emotions".format(
		{"place": record["place"],
		"emo": record["emotion"]}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)
	var image_texture_rect = _create_texture(record['face'])

	new_background.add_child(new_record)
	new_record.add_child(label)
	new_record.add_child(image_texture_rect)
	_box_container.add_child(new_background)

func _display_bad_emotional_reaction_at_authentication(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_small_label()
	var text = "The target was authenticated at {place} with {emo}, and showed one of the daily forbidden emotions. The preferred emotions were {pref_emo}".format(
		{"place": record["place"],
		"emo": record["emotion"],
		"pref_emo": _emotion_string(record['preferred_emotions'])}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)
	var image_texture_rect = _create_texture(record['face'])

	new_background.add_child(new_record)
	new_record.add_child(label)
	new_record.add_child(image_texture_rect)
	_box_container.add_child(new_background)

func _display_neutral_emotional_reaction_at_authentication(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_small_label()
	var text = "The target was authenticated at {place} with {emo}. The daily preferred emotions were {pref_emo}".format(
		{"place": record["place"],
		"emo": record["emotion"],
		"pref_emo": _emotion_string(record['preferred_emotions'])}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)
	var image_texture_rect = _create_texture(record['face'])

	new_background.add_child(new_record)
	new_record.add_child(label)
	new_record.add_child(image_texture_rect)
	_box_container.add_child(new_background)

func _display_traffic_violation(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_small_label()
	var text = "The target commited a traffic violation of type [color=red]{type}[/color] at the location {place}".format(
		{"type": record["violation_type"],
		"place": record["place"]}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)
	var image_texture_rect = _create_texture(record['screenshot'])

	new_background.add_child(new_record)
	new_record.add_child(label)
	new_record.add_child(image_texture_rect)
	_box_container.add_child(new_background)

func _display_blood_donation(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_big_label()
	var text = "The target donated blood.".format(
		{"type": record["violation_type"],
		"place": record["place"]}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)

	new_background.add_child(new_record)
	new_record.add_child(label)
	_box_container.add_child(new_background)

func _display_organ_donation(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_big_label()
	var text = "The target donated a kidney.".format(
		{"type": record["violation_type"],
		"place": record["place"]}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)

	new_background.add_child(new_record)
	new_record.add_child(label)
	_box_container.add_child(new_background)

func _display_critical_speech_in_reallife(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_small_label()
	var text = "The target criticised the government at {place} by saying: [i]{text}[/i] to {addressee}.".format(
		{"text": record["text"],
		"place": record["place"],
		"addressee": record["addressee"]}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)
	var image_texture_rect = _create_texture(record['screenshot'])

	new_background.add_child(new_record)
	new_record.add_child(label)
	new_record.add_child(image_texture_rect)
	_box_container.add_child(new_background)

func _display_fitness_studio_visit(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_big_label()
	var text = "The target visited the gym.".format(
		{}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)

	new_background.add_child(new_record)
	new_record.add_child(label)
	_box_container.add_child(new_background)
	
func _display_fitness_studio_not_visited(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_big_label()
	var text = "The target did not visited the gym for a while.".format(
		{}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)

	new_background.add_child(new_record)
	new_record.add_child(label)
	_box_container.add_child(new_background)

func _display_healthy_food_in_restaurant(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_big_label()
	var text = "The target ate {food} in the Mall.".format(
		{"food": record['food']}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)

	new_background.add_child(new_record)
	new_record.add_child(label)
	_box_container.add_child(new_background)

func _undisplay_healthy_food_in_restaurant(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_big_label()
	var text = "The target ate {food} in the Mall.".format(
		{"food": record['food']}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)

	new_background.add_child(new_record)
	new_record.add_child(label)
	_box_container.add_child(new_background)

func _display_healthy_food_at_home(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_big_label()
	var text = "The target bought {food} in the store.".format(
		{"food": record['food']}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)

	new_background.add_child(new_record)
	new_record.add_child(label)
	_box_container.add_child(new_background)

func _display_unhealthy_food_at_home(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_big_label()
	var text = "The target bought {food} in the store.".format(
		{"food": record['food']}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)

	new_background.add_child(new_record)
	new_record.add_child(label)
	_box_container.add_child(new_background)

func _display_dept(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_big_label()
	var text = "The target has depts of {amount}".format(
		{"amount": record['amount']}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)

	new_background.add_child(new_record)
	new_record.add_child(label)
	_box_container.add_child(new_background)
	
func _display_skipped_work(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_big_label()
	var text = "The target skipped work".format(
		{}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)

	new_background.add_child(new_record)
	new_record.add_child(label)
	_box_container.add_child(new_background)

func _display_too_late_to_work(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_big_label()
	var text = "The target arrived too late for work".format(
		{}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)

	new_background.add_child(new_record)
	new_record.add_child(label)
	_box_container.add_child(new_background)

func _display_didnt_visit_mom(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_big_label()
	var text = "The target didn't visit his mother for {amount} days".format(
		{"amount": record["amount_of_time"]}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)

	new_background.add_child(new_record)
	new_record.add_child(label)
	_box_container.add_child(new_background)

func _display_contact_to_dissident(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_small_label()
	var text = "The target had contact to {person}, an enemy of the society. The contact took place at {place}".format(
		{"person": record["person"],
		"place": record["place"]}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)
	var image_texture_rect = _create_texture(record['screenshot'])

	new_background.add_child(new_record)
	new_record.add_child(label)
	new_record.add_child(image_texture_rect)
	_box_container.add_child(new_background)

func _display_reported_dissident(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_big_label()
	var text = "The target reported {person}, an enemy of the society, because of {reason}".format(
		{"person": record["person"],
		"reason": record["reason"]}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)

	new_background.add_child(new_record)
	new_record.add_child(label)
	_box_container.add_child(new_background)

func _display_lied_to_boss(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var label = _create_small_label()
	var text = "The target lied to his boss".format(
		{}
	)
	if record['score'] > 0:
		label.append_bbcode("[color=green]" + str(record['score']) + "[/color]\n")
	elif record['score'] < 0:
		label.append_bbcode("[color=red]" + str(record['score']) + "[/color]\n")
	label.append_bbcode(text)
	var image_texture_rect = _create_texture(record['screenshot'])

	new_background.add_child(new_record)
	new_record.add_child(label)
	new_record.add_child(image_texture_rect)
	_box_container.add_child(new_background)

func _on_Button_pressed():
	SaveGameController.delete_game()
	get_tree().quit()
