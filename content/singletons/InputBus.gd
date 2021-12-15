extends Node

signal up_pressed
signal down_pressed
signal left_pressed
signal right_pressed

signal up_released
signal down_released
signal left_released
signal right_released

signal action_pressed
signal phone_pressed
signal menu_pressed

signal action_released
signal phone_released
signal menu_released

var direction: Vector2

func _ready():
	connect("up_pressed", self, "_on_up_pressed")
	connect("down_pressed", self, "_on_down_pressed")
	connect("left_pressed", self, "_on_left_pressed")
	connect("right_pressed", self, "_on_right_pressed")
	
	connect("up_released", self, "_on_up_released")
	connect("down_released", self, "_on_down_released")
	connect("left_released", self, "_on_left_released")
	connect("right_released", self, "_on_right_released")
	
func _on_up_pressed():
	direction = Vector2.UP

func _on_down_pressed():
	direction = Vector2.DOWN
	
func _on_left_pressed():
	direction = Vector2.LEFT
	
func _on_right_pressed():
	direction = Vector2.RIGHT
	
func _on_up_released():
	direction = Vector2.ZERO
	
func _on_down_released():
	direction = Vector2.ZERO
	
func _on_left_released():
	direction = Vector2.ZERO
	
func _on_right_released():
	direction = Vector2.ZERO
