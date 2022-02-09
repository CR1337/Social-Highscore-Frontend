extends Node2D

onready var _box_container = $Background/Margin/HBox/ScrollContainer/VBox

func _ready():
	call_deferred("_display_records")

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

func _create_header(record):
	var label = _create_label()
	label.rect_min_size = Vector2(708, 64)
	label.append_bbcode("[color=red]" + record['type'] + "[/color]\ntime: " + str(record['time']))
	return label

func _create_texture(b64image):
	var textureRect = TextureRect.new()
	textureRect.rect_min_size = Vector2(128, 128)
	textureRect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	textureRect.expand = true

	var raw_image = Marshalls.base64_to_raw(b64image)
	var image = Image.new()
	image.load_jpg_from_buffer(raw_image)

	var tmp_texture = ImageTexture.new()
	tmp_texture.create_from_image(image)
	textureRect.texture = tmp_texture
	return textureRect

func _create_info_list(record, parameter_list, label_list, fullwidth = true):
	var label = _create_label()
	label.rect_min_size = Vector2(728, 192) if fullwidth else Vector2(550, 152)
	for i in len(parameter_list):
		label.append_bbcode(
			label_list[i] + ": " +
			str(record[parameter_list[i]]) + "\n")
	return label

func _create_background():
	var new_background = ColorRect.new()
	new_background.rect_min_size = Vector2(728, 256)
	new_background.color = Color(0.5, 0.5, 0.5, 0.7)
	return new_background

func _create_record():
	var new_record = VBoxContainer.new()
	new_record.rect_min_size = Vector2(728, 256)
	new_record.alignment = BoxContainer.ALIGN_CENTER
	new_record.set("custom_constants/separation", 20)
	new_record.margin_left = 10
	new_record.margin_top = 10
	new_record.margin_bottom = 246
	new_record.margin_right = 718

	return new_record

func _display_record(record):
	match record['type']:
		'emotional_reaction_on_news':
			_display_emotional_reaction_on_news(record)
		'refused_reaction_on_news':
			_display_refused_reaction_on_news(record)
		'emotional_reaction_at_authentication':
			_display_emotional_reaction_at_authentication(record)
		_:
			var label = _create_label()
			label.rect_min_size = Vector2(728, 64)
			label.append_bbcode(record['type'])
			_box_container.add_child(label)

func _display_emotional_reaction_on_news(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var body_container = HBoxContainer.new()
	body_container.set("custom_constants/separation", 0)

	var image_texture_rect = _create_texture(record['face'])

	var info_label = _create_info_list(record,
		['score', 'news', 'preferred_emotion', 'emotion'],
		['Score Difference', 'News', 'Expected emotion', 'Actual Emotion'],
		false
	)
		# resize
	new_background.rect_min_size = Vector2(728, 288)
	new_record.rect_min_size = Vector2(728, 288)
	info_label.rect_min_size = Vector2(550, 228)

	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	body_container.add_child(info_label)
	body_container.add_child(image_texture_rect)
	new_record.add_child(body_container)
	_box_container.add_child(new_background)

func _display_refused_reaction_on_news(record):
	var new_background = _create_background()
	var new_record = _create_record()

	var info_label = _create_info_list(record,
		['score', 'news', 'preferred_emotion'],
		['Score Difference', 'News', 'Expected Emotion'],
		true
	)

	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	new_record.add_child(info_label)
	_box_container.add_child(new_background)


func _display_emotional_reaction_at_authentication(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var body_container = HBoxContainer.new()
	body_container.set("custom_constants/separation", 0)

	var image_texture_rect = _create_texture(record['face'])

	var info_label = _create_info_list(record,
		['score', 'place', 'preferred_emotion', 'reason', 'emotion'],
		['Score Difference', 'Place', 'Expected emotion', 'Reason', 'Actual Emotion'],
		false
	)
	# resize
	new_background.rect_min_size = Vector2(728, 288)
	new_record.rect_min_size = Vector2(728, 288)
	info_label.rect_min_size = Vector2(550, 228)

	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	body_container.add_child(info_label)
	body_container.add_child(image_texture_rect)
	new_record.add_child(body_container)
	_box_container.add_child(new_background)

func _display_traffic_violation(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var body_container = HBoxContainer.new()
	body_container.set("custom_constants/separation", 0)

	var image_texture_rect = _create_texture(record['screenshot'])

	var info_label = _create_info_list(record,
		['score', 'violation_type', 'place'],
		['Score Difference', 'Type of violation', 'Location'],
		false
	)
	# resize
	new_background.rect_min_size = Vector2(728, 288)
	new_record.rect_min_size = Vector2(728, 288)
	info_label.rect_min_size = Vector2(550, 228)

	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	body_container.add_child(info_label)
	body_container.add_child(image_texture_rect)
	new_record.add_child(body_container)
	_box_container.add_child(new_background)


func _display_blood_donation(record):
	var new_background = _create_background()
	var new_record = _create_record()

	var info_label = _create_info_list(record,
		['score'],
		['Score Difference'],
		true
	)
	# resize
	new_background.rect_min_size = Vector2(728, 156)
	new_record.rect_min_size = Vector2(728, 156)
	info_label.rect_min_size = Vector2(550, 156)

	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	new_record.add_child(info_label)
	_box_container.add_child(new_background)

func _display_organ_donation(record):
	var new_background = _create_background()
	var new_record = _create_record()

	var info_label = _create_info_list(record,
		['score'],
		['Score Difference'],
		true
	)

	# resize
	new_background.rect_min_size = Vector2(728, 156)
	new_record.rect_min_size = Vector2(728, 156)
	info_label.rect_min_size = Vector2(550, 156)

	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	new_record.add_child(info_label)
	_box_container.add_child(new_background)

func _display_critical_speech_in_messenger(record):
	var new_background = _create_background()
	var new_record = _create_record()

	var info_label = _create_info_list(record,
		['score', 'addressee', 'text'],
		['Score Difference', 'Addressee', 'Text'],
		true
	)
	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	new_record.add_child(info_label)
	_box_container.add_child(new_background)

func _display_critical_speech_in_reallife(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var body_container = HBoxContainer.new()
	body_container.set("custom_constants/separation", 0)

	var image_texture_rect = _create_texture(record['screenshot'])

	var info_label = _create_info_list(record,
		['score', 'addressee', 'place', 'text'],
		['Score Difference', 'Addressee', 'Location', 'Text'],
		false
	)
		# resize
	new_background.rect_min_size = Vector2(728, 288)
	new_record.rect_min_size = Vector2(728, 288)
	info_label.rect_min_size = Vector2(550, 228)

	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	body_container.add_child(info_label)
	body_container.add_child(image_texture_rect)
	new_record.add_child(body_container)
	_box_container.add_child(new_background)

func _display_fitness_studio_visit(record):
	var new_background = _create_background()
	var new_record = _create_record()

	var info_label = _create_info_list(record,
		['score'],
		['Score Difference'],
		true
	)
	# resize
	new_background.rect_min_size = Vector2(728, 156)
	new_record.rect_min_size = Vector2(728, 156)
	info_label.rect_min_size = Vector2(550, 156)

	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	new_record.add_child(info_label)
	_box_container.add_child(new_background)

func _display_fitness_studio_not_visited(record):
	var new_background = _create_background()
	var new_record = _create_record()

	var info_label = _create_info_list(record,
		['score'],
		['Score Difference'],
		true
	)
	# resize
	new_background.rect_min_size = Vector2(728, 156)
	new_record.rect_min_size = Vector2(728, 156)
	info_label.rect_min_size = Vector2(550, 156)

	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	new_record.add_child(info_label)
	_box_container.add_child(new_background)

func _display_healthy_food_in_restaurant(record):
	var new_background = _create_background()
	var new_record = _create_record()

	var info_label = _create_info_list(record,
		['score', 'food'],
		['Score Difference', 'Food choice'],
		true
	)
	# resize
	new_background.rect_min_size = Vector2(728, 196)
	new_record.rect_min_size = Vector2(728, 196)
	info_label.rect_min_size = Vector2(550, 196)

	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	new_record.add_child(info_label)
	_box_container.add_child(new_background)

func _display_unhealthy_food_in_restaurant(record):
	var new_background = _create_background()
	var new_record = _create_record()

	var info_label = _create_info_list(record,
		['score', 'food'],
		['Score Difference', 'Food choice'],
		true
	)
	# resize
	new_background.rect_min_size = Vector2(728, 196)
	new_record.rect_min_size = Vector2(728, 196)
	info_label.rect_min_size = Vector2(550, 196)
	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	new_record.add_child(info_label)
	_box_container.add_child(new_background)

func _display_healthy_food_at_home(record):
	var new_background = _create_background()
	var new_record = _create_record()

	var info_label = _create_info_list(record,
		['score', 'food'],
		['Score Difference', 'Food choice'],
		true
	)
	# resize
	new_background.rect_min_size = Vector2(728, 196)
	new_record.rect_min_size = Vector2(728, 196)
	info_label.rect_min_size = Vector2(550, 196)
	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	new_record.add_child(info_label)
	_box_container.add_child(new_background)

func _display_unhealthy_food_at_home(record):
	var new_background = _create_background()
	var new_record = _create_record()

	var info_label = _create_info_list(record,
		['score', 'food'],
		['Score Difference', 'Food choice'],
		true
	)
	# resize
	new_background.rect_min_size = Vector2(728, 196)
	new_record.rect_min_size = Vector2(728, 196)
	info_label.rect_min_size = Vector2(550, 196)
	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	new_record.add_child(info_label)
	_box_container.add_child(new_background)

func _display_dept(record):
	var new_background = _create_background()
	var new_record = _create_record()

	var info_label = _create_info_list(record,
		['score', 'amount'],
		['Score Difference', 'Dept amount'],
		true
	)
	# resize
	new_background.rect_min_size = Vector2(728, 196)
	new_record.rect_min_size = Vector2(728, 196)
	info_label.rect_min_size = Vector2(550, 196)
	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	new_record.add_child(info_label)
	_box_container.add_child(new_background)

func _display_skipped_work(record):
	var new_background = _create_background()
	var new_record = _create_record()

	var info_label = _create_info_list(record,
		['score'],
		['Score Difference'],
		true
	)
	# resize
	new_background.rect_min_size = Vector2(728, 156)
	new_record.rect_min_size = Vector2(728, 156)
	info_label.rect_min_size = Vector2(550, 156)
	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	new_record.add_child(info_label)
	_box_container.add_child(new_background)

func _display_too_late_to_work(record):
	var new_background = _create_background()
	var new_record = _create_record()

	var info_label = _create_info_list(record,
		['score', 'amount_of_time'],
		['Score Difference', 'Amount of lateness'],
		true
	)
	# resize
	new_background.rect_min_size = Vector2(728, 196)
	new_record.rect_min_size = Vector2(728, 196)
	info_label.rect_min_size = Vector2(550, 196)
	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	new_record.add_child(info_label)
	_box_container.add_child(new_background)


func _display_left_work_too_early(record):
	var new_background = _create_background()
	var new_record = _create_record()

	var info_label = _create_info_list(record,
		['score', 'amount_of_time'],
		['Score Difference', 'Amount of time'],
		true
	)
	# resize
	new_background.rect_min_size = Vector2(728, 196)
	new_record.rect_min_size = Vector2(728, 196)
	info_label.rect_min_size = Vector2(550, 196)
	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	new_record.add_child(info_label)
	_box_container.add_child(new_background)

func _display_didnt_visit_mom(record):
	var new_background = _create_background()
	var new_record = _create_record()

	var info_label = _create_info_list(record,
		['score', 'amount_of_time'],
		['Score Difference', 'Amount of time'],
		true
	)
	# resize
	new_background.rect_min_size = Vector2(728, 196)
	new_record.rect_min_size = Vector2(728, 196)
	info_label.rect_min_size = Vector2(550, 196)
	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	new_record.add_child(info_label)
	_box_container.add_child(new_background)

func _display_contact_to_dissident(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var body_container = HBoxContainer.new()
	body_container.set("custom_constants/separation", 0)

	var image_texture_rect = _create_texture(record['screenshot'])

	var info_label = _create_info_list(record,
		['score', 'person', 'place'],
		['Score Difference', 'Suspicious person', 'Location'],
		false
	)
	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	body_container.add_child(info_label)
	body_container.add_child(image_texture_rect)
	new_record.add_child(body_container)
	_box_container.add_child(new_background)

func _display_reported_dissident(record):
	var new_background = _create_background()
	var new_record = _create_record()

	var info_label = _create_info_list(record,
		['score', 'person', 'reason'],
		['Score Difference', 'Reported person', 'Reason for report'],
		true
	)
	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	new_record.add_child(info_label)
	_box_container.add_child(new_background)

func _display_lied_to_boss(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var body_container = HBoxContainer.new()
	body_container.set("custom_constants/separation", 0)

	var image_texture_rect = _create_texture(record['screenshot'])

	var info_label = _create_info_list(record,
		['score'],
		['Score Difference'],
		false
	)

	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	body_container.add_child(info_label)
	body_container.add_child(image_texture_rect)
	new_record.add_child(body_container)
	_box_container.add_child(new_background)


func _display_rescued_friend(record):
	var new_background = _create_background()
	var new_record = _create_record()
	var body_container = HBoxContainer.new()
	body_container.set("custom_constants/separation", 0)

	var image_texture_rect = _create_texture(record['screenshot'])

	var info_label = _create_info_list(record,
		['score'],
		['Score Difference'],
		false
	)

	new_background.add_child(new_record)
	new_record.add_child(_create_header(record))
	body_container.add_child(info_label)
	body_container.add_child(image_texture_rect)
	new_record.add_child(body_container)
	_box_container.add_child(new_background)

func _on_Button_pressed():
	ViewportManager.change_to_transparent()
