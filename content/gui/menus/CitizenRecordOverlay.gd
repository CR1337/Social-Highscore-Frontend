extends Node2D

onready var box_container = $Background/MarginContainer/HBoxContainer/ScrollContainer/VBoxContainer


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
	var label = Label.new()
	label.text = text
	var dynamic_font = DynamicFont.new()
	dynamic_font = load("assets/fonts/Consolas.tres")
	label.add_font_override("font", dynamic_font)
	label.add_color_override("font_color", Color(1, 1, 1, 1))
	return label
		
func _display_record(record):
	match record['type']:
		'emotional_reaction_on_news':
			_display_emotional_reaction_on_news(record)
	
func _display_emotional_reaction_on_news(record):
	var new_record = VBoxContainer.new()
	new_record.rect_min_size = Vector2(728, 128)
	var header_container = HBoxContainer.new()
	header_container.set("custom_constants/separation", 100)
	var body_container = HBoxContainer.new()
	var info_list = VBoxContainer.new()
	var image_texture_rect = TextureRect.new()

	header_container.add_child(_create_label(record['type']))
	header_container.add_child(_create_label('time: ' + str(record['time'])))
	
	var raw_image = Marshalls.base64_to_raw(record['face'])
	var image = Image.new()
	image.load_jpg_from_buffer(raw_image)
	
	var tmp_texture = ImageTexture.new()
	tmp_texture.create_from_image(image)
	TextureRect.texture = tmp_texture

	info_list.add_child(_create_label(record['news']))
	info_list.add_child(_create_label(record['emotion']))
	info_list.add_child(_create_label(record['prefered_emotion']))
	
	new_record.add_child(header_container)
	body_container.add_child(info_list)
	body_container.add_child()
	new_record.add_child(body_container)
	box_container.add_child(new_record)
#
#func _display_refused_reaction_on_news(record):
#	var params = {
#		'type': 'refused_reaction_on_news',
#		'score': score,
#		'news': news,
#		'preferred_emotion': preferred_emotion
#	}
#	_add_record(params)
#
#func add_emotional_reaction_at_authentication(score, place, face, emotion, reason, preferred_emotion):
#	var params = {
#		'type': 'emotional_reaction_at_authentication',
#		'score': score,
#		'place': place,
#		'face': face,
#		'emotion': emotion,
#		'reason': reason,
#		'preferred_emotion': preferred_emotion
#	}
#	_add_record(params)
#
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
