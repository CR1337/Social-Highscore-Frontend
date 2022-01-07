extends Node

onready var score = 1000
onready var money = 1000

# hunger and sleep in percent
onready var hunger = 100
onready var sleep = 100

onready var days_without_mom = 0
onready var fridge_filling = []
onready var current_day = 0

var next_day_handle
var next_status_update_handle

signal sleep_changed(new_value)
signal hunger_changed(new_value)

func _ready():
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
	print("Hunger: ", hunger)
	print("Sleep: ", sleep)
	
func timer(handle):
	if handle == next_day_handle:
		next_day()
		next_day_handle = TimeController.setTimer(Globals.seconds_per_day, self)
	if handle == next_status_update_handle:
		status_update()
		next_status_update_handle = TimeController.setTimer(Globals.seconds_per_day / 24, self)

func change_score(amount):
	score += amount
	
func change_money(amount):
	money += amount
	
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