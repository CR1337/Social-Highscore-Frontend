extends Node

var Area_idxs: Dictionary

var traffic_toggle_handle: int
signal change_traffic_lights

func _ready():
	traffic_toggle_handle = TimeController.setTimer(10, self)
func start_next_car(area_id, car_id):
	Area_idxs[area_id].start_car(car_id)

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

func time(handle):
	if handle == traffic_toggle_handle:
		traffic_toggle_handle = TimeController.setTimer(10, self)
		emit_signal("change_traffic_lights")
