extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	ViewportManager.player = $player
	ViewportManager.currentArea = $Areas/LivingHomestreetArea
	ViewportManager.shaderRect = $ShaderRectNode2D/ShaderRect
	
	
	ViewportManager.smartphoneMenu = $Overlays/SmartphoneMenu
	ViewportManager.gameMenu = $Overlays/GameMenu
	ViewportManager.configMenu = $Overlays/ConfigMenu
	ViewportManager.referenceImageMenu = $Overlays/ReferenceImageMenu
	ViewportManager.transparentOverlay = $Overlays/TransparentOverlay
	ViewportManager.authenticationOverlay = $Overlays/AutheticationOverlay

	ViewportManager.currentOverlay = ViewportManager.transparentOverlay
	
	TrafficController.Area_idxs = {
		'livinghomestreet': $Areas/LivingHomestreetArea,
		'livingfriendstreet': $Areas/LivingFriendstreetArea,
		'livingpharmacystreet': $Areas/LivingPharmacystreetArea,
		'livingbusstreet': $Areas/LivingBusstreetArea,
		'citybusstreet': $Areas/CityBusstreetArea,
		'cityshadystreet': $Areas/CityShadystreetArea,
		'cityjobcenterstreet': $Areas/CityJobcenterstreetArea,
		'citypolicestreet': $Areas/CityPolicestreetArea,
		'citybankstreet': $Areas/CityBankstreetArea,
		'citystorestreet': $Areas/CityStorestreetArea,
		'utilitybusstreet': $Areas/UtilityBusstreetArea,
		'utilityprisonstreet': $Areas/UtilityPrisonstreetArea
	}
	TrafficController.start_cars()
