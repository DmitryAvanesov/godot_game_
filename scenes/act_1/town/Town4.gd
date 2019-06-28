extends Node2D

func setLimits():
	GLOBAL.sceneScaleCoef = $Player.scale.x
	
	$Player/PlayerCamera.limit_top = -540
	$Player/PlayerCamera.limit_bottom = 540
	
	$Player/PlayerCamera.limit_left = -2000
	$Player/PlayerCamera.limit_right = 2000
	
	GLOBAL.leftMoveLimit = $Player/PlayerCamera.limit_left + 50
	GLOBAL.rightMoveLimit = $Player/PlayerCamera.limit_right - 50

			

func _ready():
	GLOBAL.dialog_counter += 1
	setLimits()
	pass # Replace with function body.

func _process(delta):
	$Enemy3/EnemySprite.flip_h = true
	$Enemy4/EnemySprite.flip_h = true
	pass
