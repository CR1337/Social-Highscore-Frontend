extends Node

var progress = 0
var states: Array

func persistent_state():
	return {
		'progress': progress
	}
	
func restore_state(state):
	progress = state['progress']

onready var _friend_nodes = {
	'home': get_node("/root/MainScene/Areas/LivingFriendstreetFriendArea/NpcFriend"),
	'mall': get_node("/root/MainScene/Areas/UtilityBusstreetMallArea/NpcFriend"),
	'busstreet': get_node("/root/MainScene/Areas/CityBusstreetArea/NpcFriend"), 
	'shadystreet': get_node("/root/MainScene/Areas/CityShadystreetArea/NpcFriend"),
	'partner': get_node("/root/MainScene/Areas/LivingFriendstreetPartnerArea/NpcFriend")
}

const _friend_positions = {
	'home': Vector2(8, 10),
	'mall': Vector2(10.8, 14),
	'partner': Vector2(9, 12),
	'busstreet': Vector2(7, 13),
	'shadystreet': Vector2(6, 1)
}

onready var _partner_nodes = {
	'home': get_node("/root/MainScene/Areas/LivingFriendstreetPartnerArea/NpcPartner"),
	'mall': get_node("/root/MainScene/Areas/UtilityBusstreetMallArea/NpcPartner"),
}

const _partner_positions = {
	'home': Vector2(8, 11),
	'mall': Vector2(10.8, 14)
}

const _invisible_position = Vector2(-1, -1)

const _state_change_trigger_ids = {
	'mom': 'tid_living_homestreet_mom_npc_mom_state_change',
	'friend':'tid_living_friendstreet_friend_npc_friend_state_change',
	'partner': 'tid_living_friendstreet_partner_npc_partner_state_change',
	'boss': 'tid_city_policestreet_police_npc_boss_state_change',
	'busstreet01': 'tid_city_busstreet_npc_state_change',
	'busstreet02': 'tid_city_busstreet_npc2_state_change',
	'police1': 'tid_city_policestreet_npc_police1_state_change',
	'police2': 'tid_city_policestreet_npc_police2_state_change',
	'police3': 'tid_city_policestreet_police_npc_police3_state_change',
	'police4': 'tid_city_policestreet_police_npc_police4_state_change',
	'shady1': 'tid_city_shadystreet_npc_state_change',
	'shady2': 'tid_city_shadystreet_npc2_state_change'
}

onready var _shady_nodes = {
	'shady1': get_node("/root/MainScene/Areas/CityShadystreetArea/Npc"),
	'shady2': get_node("/root/MainScene/Areas/CityShadystreetArea/Npc2")
}

func activate():
	EventBus.connect("sig_trigger", self, "_on_trigger")

func deactivate():
	EventBus.disconnect("sig_trigger", self, "_on_trigger")

func _set_npc_visibility(npc, key):
	match npc:
		'friend':
			for node in _friend_nodes.values():
				node.set_current_position(_invisible_position)
			if key != 'none':
				_friend_nodes[key].set_current_position(_friend_positions[key])
		'partner':
			for node in _partner_nodes.values():
				node.set_current_position(_invisible_position)
			if key != 'none':
				_partner_nodes[key].set_current_position(_partner_positions[key])
		'shady1':
			_shady_nodes['shady1'].set_current_position(_invisible_position)
			# shady npcs just disappear
		'shady2':
			_shady_nodes['shady2'].set_current_position(_invisible_position)
			# shady npcs just disappear


const _phone_message_filename = "res://texts/phone_messages.json"
var _phone_messages: Dictionary

func _send_phone_message(contact, text_id, important = true):
	var message = _phone_messages[text_id]
	EventBus.emit_signal("sig_got_phone_message", contact, message, important)

func _load_phone_messages():
	var file = File.new()
	file.open(_phone_message_filename, File.READ)
	_phone_messages = JSON.parse(file.get_as_text()).result
	file.close()
	
func _ready():
	states.insert(0, 'initial')
	states.append('goto_bed')
	states.append('finished')
	_load_news()
	_load_phone_messages()
	
const _news_filename = "res://texts/news.json"
var _news: Dictionary

func _load_news():
	var file = File.new()
	file.open(_news_filename, File.READ)
	_news = JSON.parse(file.get_as_text()).result
	file.close()

func _publish_news(news_id):
	var news = _news[news_id]
	NewsController.publish_news(
		news['title'],
		news['text'],
		news['preferred_emotions'],
		news['forbidden_emotions'],
		1
	)
	
func _get_day():
	return name.right(15)
	
func _set_initial_dialog():
	for tid in _state_change_trigger_ids.values():
		EventBus.emit_signal(
			"sig_trigger", tid, 
			{'new_state': "day" + _get_day() + "_initial"}
		)
	
func _update_progress(new_state):
	progress = states.find(new_state)
	if new_state == 'finished':
		_end_day()
	
func _publish_daily_news():
	var news_id = "nid_day" + _get_day()
	_publish_news(news_id)
	
func start_day():
	activate()
	_set_initial_dialog()
	GameStateController.set_day(int(_get_day()))
	_publish_daily_news()
	
func _on_trigger(trigger_id, kwargs):
	
	match trigger_id:
		'tid_bed':
			print(trigger_id)
			if progress < states.find('goto_bed'):
				ViewportManager.change_to_dialog(
					"res://dialogs/other/bed_self_talk.json",
					"todo"
				)
			else:
				ViewportManager.change_to_dialog(
					"res://dialogs/other/bed_self_talk.json",
					"go_to_bed"
				)
		'tid_end_day':
			_update_progress('finished')
	
func _end_day():
	deactivate()
	ViewportManager.blend_with_black()
	GameStateController.ticket_bought = false
	
func _request_state_change(tid, new_state):
	EventBus.emit_signal("sig_trigger", tid, {'new_state': new_state})
	
func _block_trigger(tid, block_state = 'blocked'):
	EventBus.emit_signal("sig_trigger", tid, {'action': 'block', 'block_state': block_state})

func _unblock_trigger(tid):
	EventBus.emit_signal("sig_trigger", tid, {'action': 'unblock'})
