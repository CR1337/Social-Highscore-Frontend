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
var traffic_toggle_handle = 0 # Stated in default_savegame
signal change_traffic_lights

func _ready():
	call_deferred("start_cars")

func start_next_car(area_id, car_id):
	get_node(Area_idxs[area_id]).start_car(car_id)

func start_cars():
	start_next_car('livingbusstreet', 0)
	start_next_car('livingpharmacystreet', 7)
	start_next_car('livinghomestreet', 11)

	start_next_car('citybusstreet', 15)
	start_next_car('citybusstreet', 17)
	start_next_car('citybusstreet', 19)
	start_next_car('cityshadystreet', 22)
	start_next_car('cityjobcenterstreet', 26)
	start_next_car('citystorestreet', 30)
	start_next_car('citybankstreet', 37)
	start_next_car('cityjobcenterstreet', 41)
	start_next_car('citystorestreet', 44)
	start_next_car('utilitybusstreet', 46)

func timer(handle):
	if handle == traffic_toggle_handle:
		traffic_toggle_handle = TimeController.setTimer(10, self)
		emit_signal("change_traffic_lights")
