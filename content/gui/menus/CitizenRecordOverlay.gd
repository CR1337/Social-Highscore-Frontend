extends Node2D

onready var box_container = $Background/Margin/HBox/ScrollContainer/VBox


# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("_display_records")

func _clear():
	for child in box_container.get_children():
		child.queue_free()

func display_records():
	_clear()
	for record in CitizenRecord.records:
		_display_record(record)
		print(record)

func _create_label(text):
	var label = RichTextLabel.new()
	label.rect_min_size = Vector2(728, 64)
	label.text = text
	var dynamic_font = DynamicFont.new()
	dynamic_font = load("assets/fonts/Consolas.tres")
	label.set("custom_fonts/normal_font", dynamic_font)
	label.set("custom_colors/default_color", Color(1, 1, 1, 1))
	return label
	
func _create_header(record, header_container):
	header_container.add_child(_create_label(record['type']))
	header_container.add_child(_create_label('time: ' + str(record['time'])))
	
func _create_texture(b64image, textureRect):
	var raw_image = Marshalls.base64_to_raw(b64image)
	var image = Image.new()
	image.load_jpg_from_buffer(raw_image)
	
	var tmp_texture = ImageTexture.new()
	tmp_texture.create_from_image(image)
	textureRect.texture = tmp_texture
	
func _create_info_list(record, parameter_list, label_list, list_container):
	for i in len(parameter_list):
		list_container.add_child(_create_label(
			label_list[i] + ": " + 
			str(record[parameter_list[i]])))
		
func _display_record(record):
	match record['type']:
		'emotional_reaction_on_news':
			_display_emotional_reaction_on_news(record)
		'refused_reaction_on_news':
			_display_refused_reaction_on_news(record)
		_: box_container.add_child(_create_label(record['type']))
	
func _display_emotional_reaction_on_news(record):
	var new_record = VBoxContainer.new()
	new_record.rect_min_size = Vector2(728, 128)
	var header_container = HBoxContainer.new()
	header_container.set("custom_constants/separation", 100)
	var body_container = HBoxContainer.new()
	body_container.set("custom_constants/separation", 0)
	var info_list = VBoxContainer.new()
	info_list.rect_min_size = Vector2(600, 128)
	var image_texture_rect = TextureRect.new()
	image_texture_rect.rect_min_size = Vector2(128, 128)
	image_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	image_texture_rect.expand = true

	_create_header(record, header_container)
	
	_create_texture(record['face'], image_texture_rect)
	
	_create_info_list(record,
		['score', 'news', 'preferred_emotion', 'emotion'],
		['Score Difference', 'News', 'Expected emotion', 'Actual Emotion'],
		info_list
	)
	
	new_record.add_child(header_container)
	body_container.add_child(info_list)
	body_container.add_child(image_texture_rect)
	new_record.add_child(body_container)
	box_container.add_child(new_record)

func _display_refused_reaction_on_news(record):
	var new_record = VBoxContainer.new()
	new_record.rect_min_size = Vector2(728, 128)
	var header_container = HBoxContainer.new()
	header_container.rect_min_size = Vector2(728, 32)
	header_container.set("custom_constants/separation", 100)
	var info_list = VBoxContainer.new()
	info_list.rect_min_size = Vector2(728, 96)

	_create_header(record, header_container)

	_create_info_list(record,
		['score', 'news', 'preferred_emotion'],
		['Score Difference', 'News', 'Expected Emotion'],
		info_list
	)
	
	new_record.add_child(header_container)
	new_record.add_child(info_list)
	box_container.add_child(new_record)


func _display_emotional_reaction_at_authentication(record):
	var new_record = VBoxContainer.new()
	new_record.rect_min_size = Vector2(728, 128)
	var header_container = HBoxContainer.new()
	header_container.set("custom_constants/separation", 100)
	var body_container = HBoxContainer.new()
	var info_list = VBoxContainer.new()
	var image_texture_rect = TextureRect.new()

	_create_header(record, header_container)
	
	_create_texture(record['face'], image_texture_rect)
	
	_create_info_list(record,
		['score', 'place', 'preferred_emotion', 'reason', 'emotion'],
		['Score Difference', 'Place', 'Expected emotion', 'Reason', 'Actual Emotion'],
		info_list
	)
	new_record.add_child(header_container)
	body_container.add_child(info_list)
	body_container.add_child()
	new_record.add_child(body_container)
	box_container.add_child(new_record)

#func add_traffic_violation(score, violation_type, place, screenshot):
#	var params = {
#		'type': 'traffic_violation',
#		'score': score,
#		'violation_type': violation_type,
#		'place': place,
#		'screenshot': screenshot
#	}
#	_add_record(params)
#
#func add_blood_donation(score):
#	var params = {
#		'type': 'blood_donation',
#		'score': score,
#
#	}
#	_add_record(params)
#
#func add_organ_donation(score):
#	var params = {
#		'type': 'organ_donation',
#		'score': score,
#
#	}
#	_add_record(params)
#
#func add_critical_speech_in_messenger(score, addressee, text):
#	var params = {
#		'type': 'critical_speech_in_messenger',
#		'score': score,
#		'addressee': addressee,
#		'text': text
#	}
#	_add_record(params)
#
#func add_critical_speech_in_reallife(score, addressee, text, place, screenshot):
#	var params = {
#		'type': 'critical_speech_in_reallife',
#		'score': score,
#		'addressee': addressee,
#		'text': text,
#		'place': place,
#		'screenshot': screenshot
#	}
#	_add_record(params)
#
#func add_fitness_studio_visit(score):
#	var params = {
#		'type': 'fitness_studio_visit',
#		'score': score,
#
#	}
#	_add_record(params)
#
#func add_fitness_studio_not_visited(score):
#	var params = {
#		'type': 'fitness_studio_not_visited',
#		'score': score,
#
#	}
#	_add_record(params)
#
#func add_healthy_food_in_restaurant(score, food):
#	var params = {
#		'type': 'healthy_food_in_restaurant',
#		'score': score,
#		'food': food
#	}
#	_add_record(params)
#
#func add_unhealthy_food_in_restaurant(score, food):
#	var params = {
#		'type': 'unhealthy_food_in_restaurant',
#		'score': score,
#		'food': food
#	}
#	_add_record(params)
#
#func add_healthy_food_at_home(score, food):
#	var params = {
#		'type': 'healthy_food_at_home',
#		'score': score,
#		'food': food
#	}
#	_add_record(params)
#
#func add_unhealthy_food_at_home(score, food):
#	var params = {
#		'type': 'unhealthy_food_at_home',
#		'score': score,
#		'food': food
#	}
#	_add_record(params)
#
#func add_dept(score, amount):
#	var params = {
#		'type': 'dept',
#		'score': score,
#		'amount': amount
#	}
#	_add_record(params)
#
#func add_skipped_work(score):
#	var params = {
#		'type': 'skipped_work',
#		'score': score,
#
#	}
#	_add_record(params)
#
#func add_too_late_to_work(score, amount_of_time):
#	var params = {
#		'type': 'too_late_to_work',
#		'score': score,
#		'amount_of_time': amount_of_time
#	}
#	_add_record(params)
#
#func add_left_work_too_early(score, amount_of_time):
#	var params = {
#		'type': 'left_work_too_early',
#		'score': score,
#		'amount_of_time': amount_of_time
#	}
#	_add_record(params)
#
#func add_didnt_visit_mom(score, amount_of_time):
#	var params = {
#		'type': 'didnt_visit_mom',
#		'score': score,
#		'amount_of_time': amount_of_time
#	}
#	_add_record(params)
#
#func add_contact_to_dissident(score, person, place, screenshot):
#	var params = {
#		'type': 'contact_to_dissident',
#		'score': score,
#		'person': person,
#		'place': place,
#		'screenshot': screenshot
#	}
#	_add_record(params)
#
#func add_reported_dissident(score, person, reason):
#	var params = {
#		'type': 'reported_dissident',
#		'score': score,
#		'person': person,
#		'reason': reason
#	}
#	_add_record(params)
#
#func add_lied_to_boss(score, screenshot):
#	var params = {
#		'type': 'lied_to_boss',
#		'score': score,
#		'screenshot': screenshot
#	}
#	_add_record(params)
#
#func add_rescued_friend(score, screenshot):
#	var params = {
#		'type': 'rescued_friend',
#		'score': score,
#		'screenshot': screenshot
#	}
#	_add_record(params)


func _on_Button_pressed():
	ViewportManager.change_to_transparent()
