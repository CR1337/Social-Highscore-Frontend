extends Node

var score = 1000
var money = 1000



var days_without_mom = 0

var current_day = 0

var ticket_bought = false


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
		'hunger_timer_handle': _hunger_timer_handle,
		'days_without_mom': days_without_mom,
		'fridge_content': fridge_content,
		'current_day': current_day,
		'contact_state': contact_state,
		'current_preferred_emotions': current_preferred_emotions
	}

func restore_state(state):
	score = state['score']
	money = state["money"]
	hunger = state["hunger"]
	_hunger_timer_handle = state['hunger_timer_handle']
	days_without_mom = state["days_without_mom"]
	fridge_content = state["fridge_content"]
	current_day = state["current_day"]
	current_preferred_emotions = state['current_preferred_emotions']
	
	emit_signal("sig_hunger_changed", hunger)
	
	# contact_state = state["contact_state"]
#	emit_signal("sig_sleep_changed", sleep)
	
#	emit_signal("sig_money_changed", money)
#	emit_signal("sig_score_changed", score)

var _next_day_handle = 1 # Stated in default_savegame
var _next_status_update_handle = 2 # Stated in default_savegame


signal sig_money_changed(new_value)
signal sig_score_changed(new_value)

func _ready():
	EventBus.connect("sig_add_money", self, "_on_add_money")
	EventBus.connect("sig_payment_successfull", self, "_on_payment_successfull")
	EventBus.connect("sig_payment_failed", self, "_on_payment_failure")
	EventBus.connect("sig_trigger", self, "_on_trigger")

	# DEBUG:
	increase_hunger()
	increase_hunger()
	
func _on_trigger(trigger_id, kwargs):
	if trigger_id.begins_with('tid_shopping_'):
		_shopping_event(trigger_id, kwargs)
	else:
		pass  # TODO
	
enum SCORE_CLASS {
	AAA, AA, A, B, C, D, E, X, Z	
}

func _score_class():
	if score >= 1501:
		return SCORE_CLASS.AAA
	elif score >= 1051:
		return SCORE_CLASS.AA
	elif score >= 951:
		return SCORE_CLASS.A
	elif score >= 801:
		return SCORE_CLASS.B
	elif score >= 401:
		return SCORE_CLASS.C
	elif score >= 301:
		return SCORE_CLASS.D
	elif score >= 201:
		return SCORE_CLASS.E
	elif score >= 1:
		return SCORE_CLASS.X
	else:
		return SCORE_CLASS.Z

func _next_day():
	current_day += 1
	days_without_mom += 1
	

func timer(handle):
	if handle == _next_day_handle:
		_next_day()
		_next_day_handle = TimeController.setTimer(Globals.seconds_per_day, self, "timer")
	if handle == _next_status_update_handle:
		_next_status_update_handle = TimeController.setTimer(Globals.seconds_per_day / 24, self, "timer")

func change_score(amount):
	score += amount
	emit_signal("sig_score_changed", score)

func change_money(amount):
	money += amount
	emit_signal("sig_money_changed", money)

func visited_mom():
	days_without_mom = 0




func _on_add_money(amount, description):
	change_money(amount)
	
# BEGIN shopping + fridge

enum HEALTHIENESS {
	healthy, neutral, unhealthy
}

const _food_item_prototypes = {
	'healthy_small': {
		'base_price': 20,
		'hunger_decrease': 1,
		'healthieness': HEALTHIENESS.healthy,
		'name': "fruits"
	},
	'healthy_big': {
		'base_price': 35,
		'hunger_decrease': 2,
		'healthieness': HEALTHIENESS.healthy,
		'name': "vegetable lasagna"
	},
	'neutral_small': {
		'base_price': 15,
		'hunger_decrease': 1,
		'healthieness': HEALTHIENESS.neutral,
		'name': "yogurt"
	},
	'neutral_big': {
		'base_price': 25,
		'hunger_decrease': 2,
		'healthieness': HEALTHIENESS.neutral,
		'name': "meat stew"
	},
	'unhealthy_small': {
		'base_price': 10,
		'hunger_decrease': 1,
		'healthieness': HEALTHIENESS.unhealthy,
		'name': "chocolate"
	},
	'unhealthy_big': {
		'base_price': 15,
		'hunger_decrease': 2,
		'healthieness': HEALTHIENESS.unhealthy,
		'name': "frozen burger"
	}
}

const _price_factors = {
	SCORE_CLASS.AAA: 0.7,
	SCORE_CLASS.AA: 0.8,
	SCORE_CLASS.A: 1,
	SCORE_CLASS.B: 1.2,
	SCORE_CLASS.C: 1.6,
	SCORE_CLASS.D: 2.0,
	SCORE_CLASS.E: 2.2,
	SCORE_CLASS.X: 2.4,
	SCORE_CLASS.Z: 3.0,
}

func price_factor():
	return _price_factors[_score_class()]

const _shopping_payment_handle = 'ph_shopping_success'
const fridge_capacity = 3
var fridge_content = []
var shopping_cart = []

func _shopping_event(trigger_id, kwargs):
	var add_to_cart_prefix = "tid_shopping_add_to_cart_"
	if trigger_id.begins_with(add_to_cart_prefix):
		var tid_suffix = trigger_id.trim_prefix(add_to_cart_prefix)
		_add_to_shopping_cart(_food_item_prototypes[tid_suffix])
	else:
		match trigger_id:
			"tid_shopping_pay":
				_shopping_pay()
			"tid_shopping_reset":
				_clear_shopping_cart()

func _add_to_shopping_cart(food_item):
	if fridge_capacity - (len(shopping_cart) + len(fridge_content)) > 0:
		shopping_cart.append(food_item)
	# TODO: close store doors, store counter state change
		
func _clear_shopping_cart():
	shopping_cart = []
	# TODO: open store doors, store counter state change
	
func _shopping_total_price():
	var total_price = 0
	for food_item in shopping_cart:
		total_price += food_item['base_price'] * _price_factors[_score_class()]
	return total_price

func _shopping_pay():
	ViewportManager.change_to_payment("Groceries", _shopping_total_price(), _shopping_payment_handle)
	
# handler for successful payment
func _on_payment_successfull(payment_handle):
	if payment_handle != _shopping_payment_handle:
		return
	for food_item in shopping_cart:
		fridge_content.append(food_item)
		_food_scoring(food_item)
	_clear_shopping_cart()
	
func _on_payment_failure(payment_handle):
	if payment_handle != _shopping_payment_handle:
		return
	# TODO
	
func _food_scoring(food_item):
	match food_item['healthieness']:
		HEALTHIENESS.healthy:
			CitizenRecord.add_healthy_food_at_home(2, food_item['name'])
		HEALTHIENESS.unhealthy:
			CitizenRecord.add_unhealthy_food_at_home(-15, food_item['name'])
		HEALTHIENESS.neutral:
			pass  # TODO?
	

# END shopping + fridge
	
# BEGIN hunger

signal sig_hunger_changed(new_value)

var hunger = 0
var _hunger_timer_handle = -1
const hunger_timer_start_value = 60 * 1
	
func reset_hunger():
	hunger = 0
	_handle_hunger()
	
func increase_hunger():
	hunger = min(2, hunger + 1)
	_handle_hunger()
	
func eat(amount):
	hunger -= max(amount, hunger + 1)
	_handle_hunger()
		
func _handle_hunger():
	# the signal enables the input ui to display the hunger indicator
	emit_signal("sig_hunger_changed", hunger)
	if hunger < 2:
		# disable hunger timer by forgetting handle
		_hunger_timer_handle = -1
	else:
		# start hunger timer
		_hunger_timer_handle = TimeController.setTimer(
			hunger_timer_start_value, self, "_hunger_timer"
		)

func _hunger_timer(handle):
	if handle == _hunger_timer_handle:
		_starve()
		
func _starve():
	print("STARVING")
	ViewportManager.change_to_hospital()
	# Does the position of the player gets set?
	EventBus.emit_signal("sig_trigger",
	"tid_utility_busstreet_hospital_npc_counter_state_change",
	{'new_state': "hospitalized"})
	reset_hunger()

# END hunger
