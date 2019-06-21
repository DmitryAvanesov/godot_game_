extends "res://scenes/act_1/FuncLoadScene.gd"
var n = 1.5
# the limits for the current scene	
func setLimits():
	GLOBAL.sceneScaleCoef = $Player.scale.x
	
	$Player/PlayerCamera.limit_top = -540*n
	$Player/PlayerCamera.limit_bottom = 540*n
	
	$Player/PlayerCamera.limit_left = -2000*n
	$Player/PlayerCamera.limit_right = 2000*n
	
	GLOBAL.leftMoveLimit = $Player/PlayerCamera.limit_left + 50
	GLOBAL.rightMoveLimit = $Player/PlayerCamera.limit_right - 50
	
	if GLOBAL.haveBeenInHouse:
		$To_next_location.position = Vector2(2782, 481)
		if GLOBAL.is_new_game:
			$Player.position = Vector2(926, 524)
			
func _ready():
	setLimits()