extends Node

onready var score = 1000
onready var money = 1000

# hunger and sleep in percent
onready var hunger = 100
onready var sleep = 100

onready var days_without_mom = 0
onready var fridge_filling = []
onready var current_day = 0



var price_factor = 1
var current_preferred_emotions = []

var contact_state = {
	'friend': "state0",
	'partner': "state0",
	'mom': "state0",
	'boss': "state0"
}

func persistent_state():
	return {
		'score': score,
		'money': money,
		'hunger': hunger,
		'sleep': sleep,
		'days_without_mom': days_without_mom,
		'fridge_filling': fridge_filling,
		'current_day': current_day,
		'contact_state': contact_state,
		'price_factor': price_factor,
		'current_preferred_emotions': current_preferred_emotions
	}

func restore_state(state):
	score = state['score']
	money = state["money"]
	hunger = state["hunger"]
	sleep = state["sleep"]
	days_without_mom = state["days_without_mom"]
	fridge_filling = state["fridge_filling"]
	current_day = state["current_day"]
	price_factor = state['price_factor']
	current_preferred_emotions = state['current_preferred_emotions']
	# contact_state = state["contact_state"]
#	emit_signal("sig_sleep_changed", sleep)
#	emit_signal("sig_hunger_changed", hunger)
#	emit_signal("sig_money_changed", money)
#	emit_signal("sig_score_changed", score)

var _next_day_handle = 1 # Stated in default_savegame
var _next_status_update_handle = 2 # Stated in default_savegame

signal sig_sleep_changed(new_value)
signal sig_hunger_changed(new_value)
signal sig_money_changed(new_value)
signal sig_score_changed(new_value)

func _ready():
	EventBus.connect("sig_add_money", self, "_on_add_money")
	#pass
	_next_day_handle = TimeController.setTimer(Globals.seconds_per_day, self, "timer")
	_next_status_update_handle = TimeController.setTimer(Globals.seconds_per_day / 24, self, "timer")

func _next_day():
	current_day += 1
	days_without_mom += 1

func _status_update():
	hunger -= 4
	sleep -= 5
	emit_signal("sig_sleep_changed", sleep)
	emit_signal("sig_hunger_changed", hunger)

func timer(handle):
	if handle == _next_day_handle:
		_next_day()
		_next_day_handle = TimeController.setTimer(Globals.seconds_per_day, self, "timer")
	if handle == _next_status_update_handle:
		_status_update()
		_next_status_update_handle = TimeController.setTimer(Globals.seconds_per_day / 24, self, "timer")

func change_score(amount):
	score += amount
	emit_signal("sig_score_changed", score)

func change_money(amount):
	money += amount
	emit_signal("sig_money_changed", money)

func eat(amount):
	hunger = max(hunger - amount, 0)

func sleep():
	sleep = 0

func visited_mom():
	days_without_mom = 0

func add_to_fridge(item):
	fridge_filling.append(item)

func remove_from_fridge(item):
	fridge_filling.erase(item)


func _on_add_money(amount, description):
	change_money(amount)
