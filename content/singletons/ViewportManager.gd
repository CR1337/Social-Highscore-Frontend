extends Node


var player: Area2D
var currentArea: Node2D
var shaderRect: ColorRect
var currentOverlay: Node2D
var lastOverlay: Node2D

var smartphoneMenu: Node2D
var startMenu: Node2D
var gameMenu: Node2D
var configMenu: Node2D
var dialogOverlay: Node2D
var transparentOverlay: Node2D
var newsApp: Node2D
var messengerApp: Node2D
var bankingApp: Node2D
var citizenApp: Node2D

func _ready():
	InputBus.connect("phone_pressed", self, "_on_phone_pressed")
	InputBus.connect("menu_pressed", self, "_on_menu_pressed")
	lastOverlay = transparentOverlay
	
func _on_phone_pressed():
	change_overlay(smartphoneMenu)
	
func _on_menu_pressed():
	change_overlay(gameMenu)
	
func change_to_transparent():
	change_overlay(transparentOverlay)
	
func change_to_config():
	change_overlay(configMenu)
	
func change_to_last():
	change_overlay(lastOverlay)

func change_area(targetArea, newPlayerPosition):
	shaderRect.cover()

	var tmp_position = targetArea.position
	targetArea.position = currentArea.position
	currentArea.position = tmp_position
	currentArea = targetArea
	
	player.position = newPlayerPosition * Globals.tile_size
	
	shaderRect.area_change()
	
func change_overlay(targetOverlay):
	var tmp_position = targetOverlay.position
	targetOverlay.position = currentOverlay.position
	currentOverlay.position = tmp_position
	lastOverlay = currentOverlay
	currentOverlay = targetOverlay
