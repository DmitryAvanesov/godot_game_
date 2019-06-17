extends "res://scenes/act_1/FuncLoadScene.gd"

# the limits for the current scene	
func setLimits():
	GLOBAL.sceneScaleCoef = $Player.scale.x
	
	$Player/PlayerCamera.limit_top = -540
	$Player/PlayerCamera.limit_bottom = 540
	
	$Player/PlayerCamera.limit_left = -960
	$Player/PlayerCamera.limit_right = 960
	
	$Player.leftMoveLimit = $Player/PlayerCamera.limit_left + 150
	$Player.rightMoveLimit = $Player/PlayerCamera.limit_right - 150
	
func _ready():
	setLimits()