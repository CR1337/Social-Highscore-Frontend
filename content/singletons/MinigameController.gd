extends Node

onready var _player = get_node("/root/MainScene/Player")
onready var _police_area = get_node("/root/MainScene/Areas/CityPolicestreetPoliceArea")

const _leave_trigger_ids = [
	"tid_city_busstreet_bus",
	"tid_city_jobcenterstreet_leave_jobcenter",
	"tid_city_bankstreet_leave_office",
	"tid_city_bankstreet_leave_bank",
	"tid_city_storestreet_leave_store",
	"tid_city_policestreet_leave_police"
]

func persistent_state():
	return {
		
	}
	
func restore_state(state):
	pass
	

var at_work = false
var work_timer_handle = -1
const _work_timer_start_value = 60 * 5

const _player_at_boss_position = Vector2(10, 5)

var current_work_score = 0
var t_p_counter = 0
var f_p_counter = 0
var t_n_counter = 0
var f_n_counter = 0


func reset_minigame():
	current_work_score = 0
	t_p_counter = 0
	f_p_counter = 0
	t_n_counter = 0
	f_n_counter = 0


func start():
	reset_minigame()
	ViewportManager.change_to_transparent()
	_player.is_police = true
	EventBus.emit_signal("sig_trigger", 'tid_city_policestreet_police_leave', {})
	GameStateController.pause_hunger_timer()
	at_work = true
	work_timer_handle = TimeController.setTimer(
		_work_timer_start_value, self, "work_timer"
	)
	_block_leave_triggers()

func _end():
	_unblock_leave_triggers()
	_player.is_police = false
	EventBus.emit_signal("sig_trigger", "tid_city_policestreet_police_npc_boss_state_change", {'new_state': 'debriefing'})
	ViewportManager.change_area(_police_area, _player_at_boss_position)
	EventBus.emit_signal("sig_trigger", "tid_city_policestreet_police_npc_boss_start_dialog")
	GameStateController.continue_hunger_timer()
	at_work = false

	
	
func work_timer(handle):
	if handle == work_timer_handle:
		_end()

func handle_true_positive_penalty(score):
	current_work_score += score
	t_p_counter += 1
func handle_true_negative_penalty():
	t_n_counter += 1
func handle_false_positive_penalty(score):
	current_work_score += score
	f_p_counter += 1
func handle_false_negative_penalty(score):
	current_work_score += score
	f_n_counter += 1

func loan():
	return current_work_score
	
func _block_leave_triggers():
	for tid in _leave_trigger_ids:
		EventBus.emit_signal("sig_trigger", tid, {'action': 'block', 'block_state': 'at_work'})
	
func _unblock_leave_triggers():
	for tid in _leave_trigger_ids:
		EventBus.emit_signal("sig_trigger", tid, {'action': 'unblock'})
