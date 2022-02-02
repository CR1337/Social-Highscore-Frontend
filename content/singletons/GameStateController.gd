extends Node

onready var score = 1000
onready var money = 1000

# hunger and sleep in percent
onready var hunger = 100
onready var sleep = 100

onready var days_without_mom = 0
onready var fridge_filling = []
onready var current_day = 0

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
		'contact_state': contact_state
	}

func restore_state(state):
	score = state['score']
	money = state["money"]
	hunger = state["hunger"]
	sleep = state["sleep"]
	days_without_mom = state["days_without_mom"]
	fridge_filling = state["fridge_filling"]
	current_day = state["current_day"]
	# contact_state = state["contact_state"]
#	emit_signal("sleep_changed", sleep)
#	emit_signal("hunger_changed", hunger)
#	emit_signal("sig_money_changed", money)
#	emit_signal("sig_score_changed", score)

var next_day_handle = 1 # Stated in default_savegame
var next_status_update_handle = 2 # Stated in default_savegame

signal sleep_changed(new_value)
signal hunger_changed(new_value)
signal sig_money_changed(new_value)
signal sig_score_changed(new_value)

func _ready():
	EventBus.connect("sig_add_money", self, "_on_add_money")
	#pass
	next_day_handle = TimeController.setTimer(Globals.seconds_per_day, self)
	next_status_update_handle = TimeController.setTimer(Globals.seconds_per_day / 24, self)

func next_day():
	current_day += 1
	days_without_mom += 1

func status_update():
	hunger -= 4
	sleep -= 5
	emit_signal("sleep_changed", sleep)
	emit_signal("hunger_changed", hunger)

func timer(handle):
	if handle == next_day_handle:
		next_day()
		next_day_handle = TimeController.setTimer(Globals.seconds_per_day, self)
	if handle == next_status_update_handle:
		status_update()
		next_status_update_handle = TimeController.setTimer(Globals.seconds_per_day / 24, self)

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
