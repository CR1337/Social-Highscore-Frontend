extends Node

var score = 1000
var money = 1000

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
		'hunger_timer_handle': hunger_timer_handle,
		'days_without_mom': days_without_mom,
		'days_without_fitness': _days_without_fitness,
		'fridge_content': fridge_content,
		'current_day': current_day,
		'contact_state': contact_state,
		'current_preferred_emotions': current_preferred_emotions,
		'ticket_bought': ticket_bought,
		'mall_food_timer_items': _mall_food_timer_items,
		'bank_account_blocked': bank_account_blocked,
		'bank_loan_debt': _bank_loan_debt,
		'bank_loan_daily_repayment_amount': _bank_loan_daily_repayment_amount,
		'screenshot_counter': _screenshot_counter
	}

func restore_state(state):
	score = state['score']
	money = state["money"]
	hunger = int(state["hunger"])
	hunger_timer_handle = state['hunger_timer_handle']
	days_without_mom = state["days_without_mom"]
	_days_without_fitness = state["days_without_fitness"]
	fridge_content = state["fridge_content"]
	current_day = state["current_day"]
	current_preferred_emotions = state['current_preferred_emotions']
	ticket_bought = state['ticket_bought']
	_mall_food_timer_items = state['mall_food_timer_items']
	bank_account_blocked = state['bank_account_blocked']
	_bank_loan_debt = state["bank_loan_debt"]
	_bank_loan_daily_repayment_amount = state["bank_loan_daily_repayment_amount"]
	_screenshot_counter = state['screenshot_counter']
	
	if current_day > 0:
		current_story_controller().activate()
	
	emit_signal("sig_hunger_changed", hunger)
	EventBus.emit_signal("sig_fridge_content_changed")

var _next_day_handle = 1 # Stated in default_savegame
var _next_status_update_handle = 2 # Stated in default_savegame

signal sig_money_changed(new_value)
signal sig_score_changed(new_value)
signal sig_score_class_changed()

func _ready():
	EventBus.connect("sig_add_money", self, "_on_add_money")
	EventBus.connect("sig_trigger", self, "_on_trigger")

	
func _on_trigger(trigger_id, kwargs):
	if trigger_id.begins_with('tid_shopping_'):
		_shopping_event(trigger_id, kwargs)
	elif trigger_id.begins_with('tid_loan_'):
		_handle_bank_loan(trigger_id)
	elif trigger_id == 'tid_visited_mom':
		days_without_mom = 0
	elif trigger_id == 'tid_gym_visit':
		_days_without_fitness = 0
	elif trigger_id == 'tid_critical_speech':
		_handle_critical_speech(
			kwargs.get('addressee', 'unknown person'),
			kwargs.get('place', 'unknown location'),
			kwargs.get('text', 'unknown text')
		)
	else:
		pass  # TODO
	
enum SCORE_CLASS {
	AAA, AA, A, B, C, D, E, X, Z	
}

const _score_class_name = {
	SCORE_CLASS.AAA: "AAA",
	SCORE_CLASS.AA: "AA",
	SCORE_CLASS.A: "A",
	SCORE_CLASS.B: "B",
	SCORE_CLASS.C: "C",
	SCORE_CLASS.D: "D",
	SCORE_CLASS.E: "E",
	SCORE_CLASS.X: "X",
	SCORE_CLASS.Z: "Z",
}

func score_class():
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


	
func change_score(amount):
	var _previous_score_class = score_class()
	score += amount
	if _previous_score_class != score_class():
		CitizenRecord.add_score_class_changed(_score_class_name[score_class()])
		emit_signal("sig_score_class_changed")
	emit_signal("sig_score_changed", score)

func change_money(amount):
	money += amount
	emit_signal("sig_money_changed", money)

func visited_mom():
	days_without_mom = 0

func _on_add_money(amount, description):
	change_money(amount)
	
var bank_account_blocked = false

# BEGIN story

var current_day = 1
onready var story_controllers = [
	null,
	StoryController01,
	StoryController02,
	StoryController03,
	StoryController04,
	StoryController05,
	StoryController06,
	StoryController07,
	StoryController08,
	StoryController09,
	StoryController10,
	StoryController11,
	StoryController12,
	StoryController13
]

func deactivate_all_story_controllers():
	for story_controller in story_controllers:
		if story_controller != null:
			story_controller.deactivate()

func current_story_controller():
	return story_controllers[current_day]
	
func set_day(day):
	current_day = day
	days_without_mom += 1
	_days_without_fitness += 1
	_handle_bank_loan_repayment()
	_pay_rent()
	_handle_debt_score()
	_handle_mom_vists()
	_handle_fitness_visits()
	# TODO: maybe more daily stuff

# END story

# BEGIN bank loan

const _bank_loan_interest = 10
const _bank_loan_repay_period = 8
var _bank_loan_debt = 0
var _bank_loan_daily_repayment_amount = 0

func _handle_bank_loan(trigger_id):
	if _bank_loan_debt > 0:
		EventBus.emit_signal("sig_trigger", "tid_city_bankstreet_bank_counter_already_loan", {})
	else:
		var amount = int(trigger_id.right(9))
		EventBus.emit_signal("sig_add_money", amount, 'Bank loan')
		_bank_loan_debt += amount + (amount * (_bank_loan_interest / 100))
		_bank_loan_daily_repayment_amount = ceil(_bank_loan_debt / _bank_loan_repay_period)

# END bank loan

# BEGIN daily stuff

const _punishable_days_without_mom = 2
var days_without_mom = 0
const _punishable_days_without_fitness = 2
var _days_without_fitness = 0

const _rent_price = 23
const _debt_score_factor = 0.1

func _handle_bank_loan_repayment():
	if _bank_loan_debt > 0:
		_bank_loan_debt -= _bank_loan_daily_repayment_amount
		EventBus.emit_signal(
			"sig_add_money", 
			-_bank_loan_daily_repayment_amount, 
			'Bank loan repayment'
		)
	
func _pay_rent():
	EventBus.emit_signal(
		"sig_add_money", 
		-_rent_price * price_factor(),
		'Rent'
	)
	
func _handle_debt_score():
	if money < 0:
		score = int(-money * _debt_score_factor)
		CitizenRecord.add_dept(score, money)
	
func _handle_mom_vists():
	if days_without_mom > _punishable_days_without_mom:
		var days_too_much = days_without_mom - _punishable_days_without_mom
		var score = -30 - 20 * days_too_much
		CitizenRecord.add_didnt_visit_mom(score, days_too_much)
	
func _handle_fitness_visits():
	if _days_without_fitness > _punishable_days_without_fitness:
		CitizenRecord.add_fitness_studio_not_visited(-15)

# END daily stuff
	
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
	return _price_factors[score_class()]
	
const _medication_base_price = 50
func medication_price():
	return _medication_base_price * price_factor()

const fridge_capacity = 3
var fridge_content = [{
		'base_price': 15,
		'hunger_decrease': 1,
		'healthieness': HEALTHIENESS.neutral,
		'name': "yogurt"	
}]
var shopping_cart = []

func _shopping_event(trigger_id, kwargs):
	var add_to_cart_prefix = "tid_shopping_add_to_cart_"
	if trigger_id.begins_with(add_to_cart_prefix):
		var tid_suffix = trigger_id.trim_prefix(add_to_cart_prefix)
		_add_to_shopping_cart(_food_item_prototypes[tid_suffix])
	else:
		match trigger_id:
			"tid_shopping_reset":
				_clear_shopping_cart()

func remaining_shopping_capacity():
	return fridge_capacity - (len(shopping_cart) + len(fridge_content))

func _add_to_shopping_cart(food_item):
	shopping_cart.append(food_item)
	if len(shopping_cart) == 1:
		EventBus.emit_signal("sig_trigger", "tid_city_storestreet_store_leave", {'action': 'block'})
		EventBus.emit_signal("sig_trigger", "tid_city_storestreet_store_npc_counter_state_change", {'new_state': 'filled bag'})
		EventBus.emit_signal("sig_trigger", "tid_city_storestreet_store_npc_counter2_state_change", {'new_state': 'filled bag'})

func _clear_shopping_cart():
	shopping_cart = []
	EventBus.emit_signal("sig_trigger", "tid_city_storestreet_store_leave", {'action': 'unblock'})
	EventBus.call_deferred("emit_signal","sig_trigger", "tid_city_storestreet_store_npc_counter_state_change", {'new_state': 'idle'})
	EventBus.call_deferred("emit_signal","sig_trigger", "tid_city_storestreet_store_npc_counter2_state_change", {'new_state': 'idle'})

func shopping_total_price():
	var total_price = 0
	for food_item in shopping_cart:
		total_price += food_item['base_price'] * _price_factors[score_class()]
	return total_price

func buy_shopping_cart_content():
	for food_item in shopping_cart:
		fridge_content.append(food_item)
		_food_scoring(food_item, false)
	_clear_shopping_cart()
	EventBus.emit_signal("sig_fridge_content_changed")
	
func _food_scoring(food_item, at_mall):
	if at_mall:
		match food_item['healthieness']:
			HEALTHIENESS.healthy:
				CitizenRecord.add_healthy_food_in_restaurant(2, food_item['name'])
			HEALTHIENESS.unhealthy:
				CitizenRecord.add_unhealthy_food_in_restaurant(-35, food_item['name'])
			HEALTHIENESS.neutral:
				pass  # TODO?
	else:
		match food_item['healthieness']:
			HEALTHIENESS.healthy:
				CitizenRecord.add_healthy_food_at_home(2, food_item['name'])
			HEALTHIENESS.unhealthy:
				CitizenRecord.add_unhealthy_food_at_home(-15, food_item['name'])
			HEALTHIENESS.neutral:
				pass  # TODO?

func eat_fridge_content(index):
	var food_item = fridge_content[index]
	eat(food_item['hunger_decrease'])
	fridge_content.remove(index)
	EventBus.emit_signal("sig_fridge_content_changed")
	
func delete_fridge_content_by_name(name):
	for food_item in fridge_content:
		if food_item['name'] == name:
			fridge_content.erase(food_item)
			EventBus.emit_signal("sig_fridge_content_changed")
			return
# END shopping + fridge

# BEGIN hunger

signal sig_hunger_changed(new_value)

var hunger = 0
var hunger_timer_handle = -1
const _hunger_timer_start_value = 60 * 1
	
func reset_hunger():
	hunger = 0
	_handle_hunger()
	
func increase_hunger():
	hunger = int(min(2, hunger + 1))
	_handle_hunger()
	
func eat(amount):
	hunger = int(max(-1, hunger - amount))
	_handle_hunger()
		
func _handle_hunger():
	# the signal enables the input ui to display the hunger indicator
	emit_signal("sig_hunger_changed", hunger)
	if hunger < 2:
		TimeController.delete_timer(hunger_timer_handle)
		hunger_timer_handle = -1
	else:
		# start hunger timer
		hunger_timer_handle = TimeController.setTimer(
			_hunger_timer_start_value, self, "_hunger_timer"
		)
		
func pause_hunger_timer():
	TimeController.pause_timer(hunger_timer_handle)
	
func _continue_hunger_timer():
	TimeController.continue_timer(hunger_timer_handle)

func _hunger_timer(handle):
	if handle == hunger_timer_handle:
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

# BEGIN mall buffet
var _mall_food_timer_items = {}
func get_buffet_item_price(item_key):
	return _buffet_item_prototypes[item_key]['base_price'] * price_factor()

func _score_mall_food(handle):
	var item_key = _mall_food_timer_items[handle]
	_mall_food_timer_items.erase(handle)
	_food_scoring(_buffet_item_prototypes[item_key], true)
	
func eat_mall_food(item_key):
	var food_item = _buffet_item_prototypes[item_key]
	eat(food_item['hunger_decrease'])
	var handle = TimeController.setTimer(3, self, '_score_mall_food')
	_mall_food_timer_items[handle] = item_key
	EventBus.emit_signal("sig_ate_in_mall", item_key)

const _buffet_item_prototypes = {
	'fruits': {
		'base_price': 15,
		'hunger_decrease': 1,
		'healthieness': HEALTHIENESS.healthy,
		'name': "fruits"
	},
	'fast_food': {
		'base_price': 10,
		'hunger_decrease': 2,
		'healthieness': HEALTHIENESS.unhealthy,
		'name': "fast food"
	},
	'ice_cream': {
		'base_price': 5,
		'hunger_decrease': 1,
		'healthieness': HEALTHIENESS.unhealthy,
		'name': "ice cream"
	}
}
	
# END mall buffet

var _screenshot_counter = 0
const _screenshot_path = "user://screenshots/screenshot"
# BEGIN critical speech
func _handle_critical_speech(addressee, place, text):
	var image = get_viewport().get_texture().get_data()
	var path = _screenshot_path + str(_screenshot_counter) + ".png"
	image.flip_y()
	image.crop(768, 1024)
	image.save_png(path)
	_screenshot_counter += 1
	CitizenRecord.add_critical_speech_in_reallife(
		-50,
		addressee,
		text,
		place,
		path
	)
# END critical speech
