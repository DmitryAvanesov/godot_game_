extends "res://scenes/act_1/FuncLoadScene.gd"

var dialog_timer = 0

func turn_labels_off():
	$Label.visible = false
	$Label2.visible = false

# the limits for the current scene	
func setLimits():
	GLOBAL.sceneScaleCoef = $Player.scale.x
	
	$Player/PlayerCamera.limit_top = -540
	$Player/PlayerCamera.limit_bottom = 540
	
	$Player/PlayerCamera.limit_left = -2000
	$Player/PlayerCamera.limit_right = 2000
	
	GLOBAL.leftMoveLimit = $Player/PlayerCamera.limit_left + 50
	GLOBAL.rightMoveLimit = $Player/PlayerCamera.limit_right - 50
	
	if GLOBAL.haveBeenInHouse:
		$To_next_location.position = Vector2(2782, 481)
		if GLOBAL.is_new_game:
			$Player.position = Vector2(926, 524)
			
func _ready():
	setLimits()
	turn_labels_off()
	GLOBAL.dialog_counter += 1
func _physics_process(delta):
	GLOBAL.scene = "town"
	if (!$Player/PlayerSprite.flip_h && GLOBAL.is_player_moving):
		dialog_timer += 1
	if (dialog_timer >= 0 && dialog_timer < 150):
		$Label.visible = true
	elif (dialog_timer >= 150 && dialog_timer < 250):
		$Label.visible = false
		$Label2.visible = true