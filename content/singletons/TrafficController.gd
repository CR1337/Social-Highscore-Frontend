extends Node

onready var _area_idxs = {
	'livinghomestreet': "/root/mainScene/Areas/LivingHomestreetArea",
	'livingfriendstreet': "/root/mainScene/Areas/LivingFriendstreetArea",
	'livingpharmacystreet': "/root/mainScene/Areas/LivingPharmacystreetArea",
	'livingbusstreet': "/root/mainScene/Areas/LivingBusstreetArea",
	'citybusstreet': "/root/mainScene/Areas/CityBusstreetArea",
	'cityshadystreet': "/root/mainScene/Areas/CityShadystreetArea",
	'cityjobcenterstreet': "/root/mainScene/Areas/CityJobcenterstreetArea",
	'citypolicestreet': "/root/mainScene/Areas/CityPolicestreetArea",
	'citybankstreet': "/root/mainScene/Areas/CityBankstreetArea",
	'citystorestreet': "/root/mainScene/Areas/CityStorestreetArea",
	'utilitybusstreet': "/root/mainScene/Areas/UtilityBusstreetArea",
	'utilityprisonstreet': "/root/mainScene/Areas/UtilityPrisonstreetArea"
}
var _traffic_toggle_handle = 0
signal sig_change_traffic_lights

func start_next_car(area_id, car_id):
	get_node(_area_idxs[area_id]).start_car(car_id)

func start_cars():
	_traffic_toggle_handle = TimeController.setTimer(10, self, "timer")
	EventBus.emit_signal("sig_trigger", 'tid_living_busstreet_car_1_0_start', {})
	EventBus.emit_signal("sig_trigger", 'tid_living_pharmacystreet_car_2_2_start', {})
	EventBus.emit_signal("sig_trigger", 'tid_living_homestreet_car_3_1_start', {})
	EventBus.emit_signal("sig_trigger", 'tid_city_busstreet_car_4_0_start', {})
	EventBus.emit_signal("sig_trigger", 'tid_city_busstreet_car_5_0_start', {})
	EventBus.emit_signal("sig_trigger", 'tid_city_busstreet_car_6_0_start', {})
	EventBus.emit_signal("sig_trigger", 'tid_city_shadystreet_car_7_1_start', {})
	EventBus.emit_signal("sig_trigger", 'tid_city_jobcenterstreet_car_8_1_start', {})
	EventBus.emit_signal("sig_trigger", 'tid_city_storestreet_car_9_0_start', {})
	EventBus.emit_signal("sig_trigger", 'tid_city_bankstreet_car_10_0_start', {})
	EventBus.emit_signal("sig_trigger", 'tid_city_jobcenterstreet_car_11_4_start', {})
	EventBus.emit_signal("sig_trigger", 'tid_city_storestreet_car_12_0_start', {})
	EventBus.emit_signal("sig_trigger", 'tid_utility_busstreet_car_14_0_start', {})


	
func timer(handle):
	if handle == _traffic_toggle_handle:
		_traffic_toggle_handle = TimeController.setTimer(10, self, "timer")
		emit_signal("sig_change_traffic_lights")

func persistent_state():
	return {
		'traffic_toggle_handle': _traffic_toggle_handle
	}

func restore_state(jsonstate):
	_traffic_toggle_handle = jsonstate['traffic_toggle_handle']
