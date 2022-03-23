extends "res://content/areas/Street.gd"

export (NodePath) var leave_prison_area_path
export (Vector2) var leave_prison_player_position

func _ready():

	$LeavePrisonTriggerArea/LeavePrisonTrigger.target_area = get_node(leave_prison_area_path)
	$LeavePrisonTriggerArea/LeavePrisonTrigger.new_player_position = leave_prison_player_position
