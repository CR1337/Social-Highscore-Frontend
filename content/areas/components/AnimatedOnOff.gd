tool
extends Node2D

export var frames: SpriteFrames

export var is_on: bool setget _setIsOn, _getIsOn
func _setIsOn(value):
	is_on = value
	if value:
		$AnimatedSprite.animation = on_animation_name
		$TriggerArea.walkable = walkable_when_on
	else:
		$AnimatedSprite.animation = off_animation_name
		$TriggerArea.walkable = walkable_when_off
func _getIsOn():
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

export var triggerAreaOffset: Vector2 setget _setTriggerAreaOffset, _getTriggerAreaOffset
func _setTriggerAreaOffset(value):
	$TriggerArea.position = value
	triggerAreaOffset = value
func _getTriggerAreaOffset():
	return triggerAreaOffset
	
export var triggerAreaScale: Vector2 setget _setTriggerAreaScale, _getTriggerAreaScale
func _setTriggerAreaScale(value):
	$TriggerArea.scale = value
	triggerAreaScale = value
func _getTriggerAreaScale():
	return triggerAreaScale	
	
func _ready():
	$AnimatedSprite.frames = frames
	$ActionTrigger.id = "tid_" + str(get_path()) + "_action_trigger"
	$TriggerArea.action_trigger_id = $ActionTrigger.id
	_setIsOn(is_on)

func trigger():
	_setIsOn(not is_on)
