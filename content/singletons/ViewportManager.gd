extends Node

onready var _debug_menu = get_node("/root/MainScene/Overlays/DebugMenu")

onready var config_menu = get_node("/root/MainScene/Overlays/ConfigMenu")
onready var reference_image_menu = get_node("/root/MainScene/Overlays/ReferenceImageMenu")

onready var _player = get_node("/root/MainScene/Player")
onready var _shader_rect = get_node("/root/MainScene/ShaderRectNode/ShaderRect")

onready var _hospital_area = get_node("/root/MainScene/Areas/UtilityBusstreetHospitalArea")

onready var _transparent_overlay = get_node("/root/MainScene/Overlays/TransparentOverlay")
onready var _smartphone_menu = get_node("/root/MainScene/Overlays/SmartphoneMenu")
onready var _game_menu = get_node("/root/MainScene/Overlays/GameMenu")
onready var _authentication_overlay = get_node("/root/MainScene/Overlays/AuthenticationOverlay")
onready var _payment_overlay = get_node("/root/MainScene/Overlays/PaymentOverlay")

onready var _bus_menu = get_node("/root/MainScene/Overlays/BusMenu")
onready var _fridge_overlay = get_node("/root/MainScene/Overlays/FridgeOverlay")

onready var _messenger_contacts_overlay = get_node("/root/MainScene/Overlays/MessengerAppContacts")
onready var _messenger_messages_overlay = get_node("/root/MainScene/Overlays/MessengerAppMessages")
onready var _banking_app_overlay = get_node("/root/MainScene/Overlays/BankingApp")
onready var _citizen_app_overlay = get_node("/root/MainScene/Overlays/CitizenApp")
onready var _news_app_mainpage_overlay = get_node("/root/MainScene/Overlays/NewsAppMainpage")
onready var _news_app_newspage_overlay = get_node("/root/MainScene/Overlays/NewsAppNewspage")

onready var _transparent_dialog_overlag = get_node("/root/MainScene/Overlays/TransparentDialog")
onready var _dialog_overlay = get_node("/root/MainScene/Overlays/DialogOverlay")

onready var _citizen_record_overlay = get_node("/root/MainScene/Overlays/CitizenRecordOverlay")
onready var _citizen_record_cover_overlay = get_node("/root/MainScene/Overlays/CitizenRecordCoverOverlay")


onready var _transparent_notification_overlay = get_node("/root/MainScene/Overlays/TransparentNotificationOverlay")
onready var _notification_overlay = get_node("/root/MainScene/Overlays/NotificationOverlay")

onready var _current_area = get_node("/root/MainScene/Areas/LivingHomestreetArea")
onready var _current_overlay = _transparent_overlay
onready var _last_overlay = _transparent_overlay
onready var _current_notification_overlay = _transparent_notification_overlay
onready var _current_dialog_overlay = _transparent_dialog_overlag

onready var _briefing_overlay = get_node("/root/MainScene/Overlays/BriefingOverlay")
onready var _debriefing_overlay = get_node("/root/MainScene/Overlays/DebriefingOverlay")

onready var _prolog_overlay = get_node("/root/MainScene/Overlays/PrologOverlay")
onready var _gameover_overlay = get_node("/root/MainScene/Overlays/GameoverOverlay")

func persistent_state():
	return {
		'current_area': _current_area.get_path(),
		'current_overlay': _current_overlay.get_path(),
		'last_overlay': _last_overlay.get_path()
	}

func restore_state(state):
	var new_current_area = get_node(state['current_area'])

	var tmp_position = new_current_area.position
	new_current_area.position = _current_area.position
	_current_area.position = tmp_position

	_current_area = new_current_area

	if get_node(state['current_overlay']) == _prolog_overlay:
		_prolog_overlay.reset()
	change_overlay(get_node(state['current_overlay']))
	_last_overlay = get_node(state['last_overlay'])

func _ready():
	InputBus.connect("sig_phone_pressed", self, "_on_phone_pressed")
	InputBus.connect("sig_menu_pressed", self, "_on_menu_pressed")
	# _last_overlay = _transparent_overlay

func current_place_string():
	return _current_area.human_readable_name
	
func _on_phone_pressed():
	change_to_smartphone()

func _on_menu_pressed():
	change_to_menu()
	
func change_to_menu():
	change_overlay(_game_menu)
	
func change_to_prolog():
	_prolog_overlay.reset()
	change_overlay(_prolog_overlay)
	
func change_to_gameover(reason):
	_gameover_overlay.prepare_gameover_overlay(reason)
	change_overlay(_gameover_overlay)
	
func change_to_notification():
	change_notification_overlay(_notification_overlay)

func change_to_transparent_notification():
	change_notification_overlay(_transparent_notification_overlay)

func change_to_transparent():
	change_overlay(_transparent_overlay)

func change_to_config():
	change_overlay(config_menu)

func change_to_refenreceImage():
	change_overlay(reference_image_menu)
	
func change_to_fridge():
	change_overlay(_fridge_overlay)

func change_to_messenger_contacts():
	change_overlay(_messenger_contacts_overlay)

func change_to_banking_app():
	change_overlay(_banking_app_overlay)

func change_to_citizen_app():
	change_overlay(_citizen_app_overlay)

func change_to_citizen_record_overlay():
	change_overlay(_citizen_record_cover_overlay)
	_citizen_record_cover_overlay.show()

func change_to_citizen_record():
	change_overlay(_citizen_record_overlay)
	_citizen_record_overlay.display_records()

func change_to_news_app_mainpage():
	_news_app_mainpage_overlay.update_mainpage()
	change_overlay(_news_app_mainpage_overlay)

func change_to_news_app_newspage(news_index):
	_news_app_newspage_overlay.update_newspage(news_index)
	change_overlay(_news_app_newspage_overlay)

func change_to_smartphone():
	change_overlay(_smartphone_menu)

func change_to_messenger_messages(contact):
	_messenger_messages_overlay.set_current_contact(contact)
	change_overlay(_messenger_messages_overlay)

func change_to_last():
	change_overlay(_last_overlay)

func change_to_dialog(json_filename, state):
	_dialog_overlay.initialize(json_filename, state)
	change_dialog_overlay(_dialog_overlay)
	
func change_to_transparent_dialog():
	change_dialog_overlay(_transparent_dialog_overlag)

func change_to_authentication(post_authentication_trigger_id):
	_authentication_overlay.post_authentication_trigger_id = post_authentication_trigger_id
	change_overlay(_authentication_overlay)

func change_to_payment(recipient, amount, payment_handle):
	_payment_overlay.update_payment(recipient, amount, payment_handle)
	change_overlay(_payment_overlay)

func change_to_briefing():
	_briefing_overlay.start_briefing(GameStateController.current_day)
	change_overlay(_briefing_overlay)
	
func change_to_debriefing():
	_debriefing_overlay.show_debriefing()
	change_overlay(_debriefing_overlay)

func change_to_bus():
	change_overlay(_bus_menu)
	
func change_to_hospital():
	change_area(_hospital_area, Vector2(11, 12))
	
func blend_with_black():
	_shader_rect.blend_with_color('black')
	
func blend_with_green():
	_shader_rect.blend_with_color('green')
	
func blend_with_red():
	_shader_rect.blend_with_color('red')

func change_area(target_area, new_player_position):
	_shader_rect.cover()
	if _current_area.get('active') != null:
		_current_area.active = false
	if target_area.get('active') != null:
		target_area.active = true
	var tmp_position = target_area.position
	target_area.position = _current_area.position
	_current_area.position = tmp_position
	_current_area = target_area

	if new_player_position.y >= 0:
		_player.position.y = (new_player_position.y - 0.5) * Globals.tile_size
	if new_player_position.x >= 0:
		_player.position.x = (new_player_position.x - 0.5) * Globals.tile_size
	blend_with_black()

func change_overlay(target_overlay):
	var tmp_position = target_overlay.position
	target_overlay.position = _current_overlay.position
	_current_overlay.position = tmp_position
	_last_overlay = _current_overlay
	_current_overlay = target_overlay

func change_notification_overlay(target_overlay):
	var tmp_position = target_overlay.position
	target_overlay.position = _current_notification_overlay.position
	_current_notification_overlay.position = tmp_position
	_current_notification_overlay = target_overlay

func change_dialog_overlay(target_overlay):
	var tmp_position = target_overlay.position
	target_overlay.position = _current_dialog_overlay.position
	_current_dialog_overlay.position = tmp_position
	_current_dialog_overlay = target_overlay

func change_to_debug():
	_debug_menu._update_debug_menu()
	change_overlay(_debug_menu)
