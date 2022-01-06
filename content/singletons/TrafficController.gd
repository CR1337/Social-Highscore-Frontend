extends Node

var Area_idxs: Dictionary


func start_next_car(area_id, car_id):
	print("next_car ", car_id)
	Area_idxs[area_id].start_car(car_id)
