extends "res://content/singletons/story_controllers/StoryController.gd"

var corrected_boss = false

func persistent_state():
	var state = .persistent_state()
	state['corrected_boss'] = corrected_boss
	return state
	
func restore_state(state):
	.restore_state(state)
	corrected_boss = state['corrected_boss']

func _ready():
	states = [
		'goto_work',
		'in_park',
		'in_operation',
		'post_operation',
		'in_prison'
	]
	._ready()

func activate():
	.activate()
	
func deactivate():
	.deactivate()

func _update_progress(new_state):
	._update_progress(new_state)
	match new_state:
		'goto_work':
			if not corrected_boss:
				_request_state_change(
					_state_change_trigger_ids['boss'],
					'day12_initial_not_corrected'
				)
		'in_park':
			_blend_to_busstreet()
			if not corrected_boss:
				_request_state_change(
					_state_change_trigger_ids['boss'],
					'day12_in_park_not_corrected'
				)
			else:
				_request_state_change(
					_state_change_trigger_ids['boss'],
					'day12_in_park'
				)
		'in_operation':
			_start_operation()
			if corrected_boss:
				_request_state_change(
					_state_change_trigger_ids['boss'],
					'day12_in_operation_corrected'
				)
			else:
				_request_state_change(
					_state_change_trigger_ids['boss'],
					'day12_in_operation_not_corrected'
				)
		'post_operation':
			_blend_to_police()
			_request_state_change(
				_state_change_trigger_ids['boss'],
				'day12_post_operation'
			)
			_request_state_change(
				_state_change_trigger_ids['mom'],
				'day12_post_work'
			)
			_request_state_change(
				_state_change_trigger_ids['partner'],
				'day12_post_work'
			)
			_request_state_change(
				_state_change_trigger_ids['police1'],
				'day12_post_work'
			)
			_request_state_change(
				_state_change_trigger_ids['police2'],
				'day12_post_work'
			)
			_request_state_change(
				_state_change_trigger_ids['police3'],
				'day12_post_work'
			)
		'in_prison':
			_blend_to_prison()
			_request_state_change(
				_state_change_trigger_ids['boss'],
				'day12_in_prison'
			)

func start_day():
	.start_day()
	_bus_npc1.set_current_position(_invisible_position)
	_bus_npc2.set_current_position(_invisible_position)
	_set_npc_visibility('friend', 'none')
	_update_progress('goto_work')


func _on_trigger(trigger_id, kwargs):
	match trigger_id:
		'tid_day12_blend_to_busstreet':
			_update_progress('in_park')
		'tid_day12_start_operation':
			_update_progress('in_operation')
		'tid_day12_blend_to_police':
			_update_progress('post_operation')
		'tid_day12_blend_to_prison':
			_update_progress('in_prison')
		'tid_read_citizen_record':
			ViewportManager.change_to_citizen_record_overlay()
		_: 
			._on_trigger(trigger_id, kwargs)

func _end_day():
	_bus_npc1.set_current_position(_bus_npc1_position)
	_bus_npc2.set_current_position(_bus_npc2_position)
	StoryController13.start_day()
	._end_day()
	
onready var _busstreet_area = get_node("/root/MainScene/Areas/CityBusstreetArea")
onready var _police_area = get_node("/root/MainScene/Areas/CityPolicestreetPoliceArea")
onready var _prison_area = get_node("/root/MainScene/Areas/UtilityPrisonstreetPrisonArea")	
	
onready var _player = get_node("/root/MainScene/Player")
const _player_operation_position = Vector2(8, 12)
const _player_police_position = Vector2(10, 5)
const _player_prison_position = Vector2(10, 10)

onready var _bus_npc1 = get_node("/root/MainScene/Areas/CityBusstreetArea/Npc")
onready var _bus_npc2 = get_node("/root/MainScene/Areas/CityBusstreetArea/Npc")
const _bus_npc1_position = Vector2(8, 6)
const _bus_npc2_position = Vector2(9, 6)
	
onready var _operation_npcs = {
	'friend': _friend_nodes['busstreet'],
	'boss': get_node("/root/MainScene/Areas/CityBusstreetArea/NpcBoss"),
	'rebel1': get_node("/root/MainScene/Areas/CityBusstreetArea/NpcRebel1"),
	'rebel2': get_node("/root/MainScene/Areas/CityBusstreetArea/NpcRebel2"),
	'rebel3': get_node("/root/MainScene/Areas/CityBusstreetArea/NpcRebel3"),
	'police1': get_node("/root/MainScene/Areas/CityBusstreetArea/NpcPolice1"),
	'police2': get_node("/root/MainScene/Areas/CityBusstreetArea/NpcPolice2"),
	'police3': get_node("/root/MainScene/Areas/CityBusstreetArea/NpcPolice3")
}

const _operation_npc_positions = {
	'friend': _friend_positions['busstreet'],
	'boss': Vector2(7, 12),
	'rebel1': Vector2(6, 14),
	'rebel2': Vector2(8, 14),
	'rebel3': Vector2(7, 15),
	'police1': Vector2(9, 15),
	'police2': Vector2(5, 15),
	'police3': Vector2(5, 12)
}

const _operation_rebel_npc_keys = [
	'friend', 'rebel1', 'rebel2', 'rebel3'
]
	
func _blend_to_busstreet():
	ViewportManager.change_area(_busstreet_area, _player_operation_position)
	_player.visible = false
	_player.looking_direction = Vector2.LEFT
	for key in _operation_rebel_npc_keys:
		_operation_npcs[key].set_current_position(_operation_npc_positions[key])
	
func _start_operation():
	ViewportManager.blend_with_black()
	_player.visible = true
	for key in _operation_npcs.keys():
		_operation_npcs[key].set_current_position(_operation_npc_positions[key])
	for key in _operation_rebel_npc_keys:
		_operation_npcs[key].set_looking_direction(Vector2.UP)
	
func _blend_to_police():
	ViewportManager.change_area(_police_area, _player_police_position)
	for key in _operation_npcs.keys():
		_operation_npcs[key].set_current_position(_invisible_position)
	
func _blend_to_prison():
	ViewportManager.change_area(_prison_area, _player_prison_position)
	for key in _operation_npcs.keys():
		_operation_npcs[key].set_current_position(_invisible_position)
