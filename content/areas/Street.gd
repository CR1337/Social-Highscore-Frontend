extends Node2D

export (NodePath) var leaveLeftAreaPath
export (Vector2) var leaveLeftPlayerPosition

export (NodePath) var leaveRightAreaPath
export (Vector2) var leaveRightPlayerPosition

export (NodePath) var leaveTopAreaPath
export (Vector2) var leaveTopPlayerPosition

export (NodePath) var leaveBottomAreaPath
export (Vector2) var leaveBottomPlayerPosition

onready var cars: Dictionary

func _ready():
	if leaveLeftAreaPath != "":
		$LeaveLeftTrigger.targetArea = get_node(leaveLeftAreaPath)
		$LeaveLeftTrigger.newPlayerPosition = leaveLeftPlayerPosition
	if leaveRightAreaPath != "":
		$LeaveRightTrigger.targetArea = get_node(leaveRightAreaPath)
		$LeaveRightTrigger.newPlayerPosition = leaveRightPlayerPosition
	if leaveTopAreaPath != "":
		$LeaveTopTrigger.targetArea = get_node(leaveTopAreaPath)
		$LeaveTopTrigger.newPlayerPosition = leaveTopPlayerPosition
	if leaveBottomAreaPath != "":
		$LeaveBottomTrigger.targetArea = get_node(leaveBottomAreaPath)
		$LeaveBottomTrigger.newPlayerPosition = leaveBottomPlayerPosition

func start_car(car_id):
	cars[car_id].start()
