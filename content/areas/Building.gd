extends Node2D

export (NodePath) var leave_area_path
export (Vector2) var leave_player_position


func _ready():
	if leave_area_path != "":
		$TriggerArea/LeaveTrigger.target_area = get_node(leave_area_path)
		$TriggerArea/LeaveTrigger.new_player_position = leave_player_position

