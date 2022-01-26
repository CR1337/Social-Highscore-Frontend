extends Node

onready var Area_idxs = {
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
var traffic_toggle_handle = 0
signal change_traffic_lights

func _ready():
	traffic_toggle_handle = TimeController.setTimer(10, self)

func start_next_car(area_id, car_id):
	get_node(Area_idxs[area_id]).start_car(car_id)

func start_cars():
	EventBus.emit_signal("trigger", 'tid_living_busstreet_car_1_0_start')
	EventBus.emit_signal("trigger", 'tid_living_pharmacystreet_car_2_2_start')
	EventBus.emit_signal("trigger", 'tid_living_homestreet_car_3_1_start')
	EventBus.emit_signal("trigger", 'tid_city_busstreet_car_4_0_start')
	EventBus.emit_signal("trigger", 'tid_city_busstreet_car_5_0_start')
	EventBus.emit_signal("trigger", 'tid_city_busstreet_car_6_0_start')
	EventBus.emit_signal("trigger", 'tid_city_shadystreet_car_7_1_start')
	EventBus.emit_signal("trigger", 'tid_city_jobcenterstreet_car_8_1_start')
	EventBus.emit_signal("trigger", 'tid_city_storestreet_car_9_0_start')
	EventBus.emit_signal("trigger", 'tid_city_bankstreet_car_10_0_start')
	EventBus.emit_signal("trigger", 'tid_city_jobcenterstreet_car_11_4_start')
	EventBus.emit_signal("trigger", 'tid_city_storestreet_car_12_0_start')
	EventBus.emit_signal("trigger", 'tid_utility_busstreet_car_14_0_start')
	
func timer(handle):
	if handle == traffic_toggle_handle:
		traffic_toggle_handle = TimeController.setTimer(10, self)
		emit_signal("change_traffic_lights")
