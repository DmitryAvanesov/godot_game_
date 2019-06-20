extends "res://scenes/act_1/FuncLoadScene.gd"

# the limits for the current scene	
func setLimits():
	GLOBAL.sceneScaleCoef = $Player.scale.x
	
	
	$Player/PlayerCamera.limit_top = -540
	$Player/PlayerCamera.limit_bottom = 540
	
	$Player/PlayerCamera.limit_left = -7500
	$Player/PlayerCamera.limit_right = 7500
	
	$Player.leftMoveLimit = $Player/PlayerCamera.limit_left + 50
	$Player.rightMoveLimit = $Player/PlayerCamera.limit_right - 50
	
func _ready():
	setLimits()