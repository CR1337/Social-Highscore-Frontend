tool
extends Node2D

export var frames: SpriteFrames

export var is_on: bool setget _set_is_on, _get_is_on
func _set_is_on(value):
	is_on = value
	if value:
		$AnimatedSprite.animation = on_animation_name
		$TriggerArea.walkable = walkable_when_on
	else:
		$AnimatedSprite.animation = off_animation_name
		$TriggerArea.walkable = walkable_when_off
func _get_is_on():
	return is_on

export var walkable_when_on: bool
export var walkable_when_off: bool

export var on_animation_name: String setget _set_on_animation_name, _get_on_animation_name
func _set_on_animation_name(value):
	on_animation_name = value
func _get_on_animation_name():
	return on_animation_name
export var off_animation_name: String setget _set_off_animation_name, _get_off_animation_name
func _set_off_animation_name(value):
	off_animation_name = value
func _get_off_animation_name():
	return off_animation_name

export var trigger_area_offset: Vector2 setget _set_trigger_area_offset, _get_trigger_area_offset
func _set_trigger_area_offset(value):
	$TriggerArea.position = value
	trigger_area_offset = value
func _get_trigger_area_offset():
	return trigger_area_offset

export var trigger_area_scale: Vector2 setget _set_trigger_area_scale, _get_trigger_area_scale
func _set_trigger_area_scale(value):
	$TriggerArea.scale = value
	trigger_area_scale = value
func _get_trigger_area_scale():
	return trigger_area_scale

func _ready():
	$AnimatedSprite.frames = frames
	$ActionTrigger.id = "tid_" + str(get_path()) + "_action_trigger"
	$TriggerArea.action_trigger_id = $ActionTrigger.id
	_set_is_on(is_on)

func trigger():
	_set_is_on(not is_on)
