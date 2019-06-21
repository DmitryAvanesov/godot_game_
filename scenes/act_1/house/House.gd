extends "res://scenes/act_1/FuncLoadScene.gd"

# the limits for the current scene	
func setLimits():
	GLOBAL.sceneScaleCoef = $Player.scale.x
	
	$Player/PlayerCamera.limit_top = -540
	$Player/PlayerCamera.limit_bottom = 540
	
	$Player/PlayerCamera.limit_left = -1080
	$Player/PlayerCamera.limit_right = 1080
	
	GLOBAL.leftMoveLimit = $Player/PlayerCamera.limit_left + 150
	GLOBAL.rightMoveLimit = $Player/PlayerCamera.limit_right - 150
	
func _ready():
	setLimits()
	
func _physics_process(delta):
	if (GLOBAL.playerCoordinates.x > -450 && GLOBAL.playerCoordinates.x < -150 && GLOBAL.playerCoordinates.y > 0):
		$Label.visible = true
	else:
		$Label.visible = false