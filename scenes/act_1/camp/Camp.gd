extends "res://scenes/act_1/FuncLoadScene.gd"
var n = 2.2

# the limits for the current scene	
func setLimits():
	GLOBAL.sceneScaleCoef = $Player.scale.x
	
	$Player/PlayerCamera.limit_top = -900*n
	$Player/PlayerCamera.limit_bottom = 900*n
	
	$Player/PlayerCamera.limit_left = -2100*n
	$Player/PlayerCamera.limit_right = 2100*n
	
	GLOBAL.leftMoveLimit = $Player/PlayerCamera.limit_left + 150
	GLOBAL.rightMoveLimit = $Player/PlayerCamera.limit_right - 150
	
func _ready():
	setLimits()
func _physics_process(delta):
	GLOBAL.scene = "camp"
	GLOBAL.sceneScaleCoef = 1