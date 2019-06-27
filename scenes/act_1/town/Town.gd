extends "res://scenes/act_1/FuncLoadScene.gd"

var dialog_timer = 0

func turn_labels_off():
	$Label1.visible = false
	$Label2.visible = false
	$Label3.visible = false
	$Label4.visible = false
	$Label5.visible = false
	$Label6.visible = false
	$Label7.visible = false
	
func dialog_counter_is_2():
	if (dialog_timer >= 0 && dialog_timer < 150):
		$Label1.visible = true
	elif (dialog_timer >= 150 && dialog_timer < 250):
		$Label1.visible = false
		$Label2.visible = true
	elif (dialog_timer >= 350 && dialog_timer < 450):
		$Label2.visible = false
		$Label3.visible = true
	elif (dialog_timer >= 700 && dialog_timer < 750):
		$Label3.visible = false
		$Label4.visible = true
	elif (dialog_timer >= 750 && dialog_timer < 800):
		$Label5.visible = true
	elif (dialog_timer >= 800 && dialog_timer < 850):
		$Label6.visible = true
	elif (dialog_timer >= 850 && dialog_timer < 900):
		$Label7.visible = true
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
	elif ($Player/PlayerSprite.flip_h && GLOBAL.is_player_moving):
		dialog_timer -= 1
	if (GLOBAL.dialog_counter == 2):
		dialog_counter_is_2()