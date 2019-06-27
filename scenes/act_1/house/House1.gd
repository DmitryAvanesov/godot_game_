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

# the limits for the current scene	
func setLimits():
	GLOBAL.sceneScaleCoef = $Player.scale.x
	
	$Player/PlayerCamera.limit_top = -540
	$Player/PlayerCamera.limit_bottom = 540
	
	$Player/PlayerCamera.limit_left = -1080
	$Player/PlayerCamera.limit_right = 1080
	
	GLOBAL.leftMoveLimit = $Player/PlayerCamera.limit_left + 150
	GLOBAL.rightMoveLimit = $Player/PlayerCamera.limit_right - 150

func talk_to_daughter():
	if (GLOBAL.talked_to_daughter && dialog_timer < 802):
		dialog_timer += 1
		if (dialog_timer > 0 && dialog_timer < 100):
			$Label1.visible = true
		elif (dialog_timer >= 100 && dialog_timer < 200):
			$Label1.visible = false
			$Label2.visible = true
		elif (dialog_timer >= 200 && dialog_timer < 400):
			$Label2.visible = false
			$Label3.visible = true
		elif (dialog_timer >= 400 && dialog_timer < 600):
			$Label3.visible = false
			$Label4.visible = true
		elif (dialog_timer >= 600 && dialog_timer < 800):
			$Label4.visible = false
			$Label5.visible = true
		elif (dialog_timer > 800):
			$Label5.visible = false
			
			
func talk_to_enemy2():
	if (GLOBAL.is_player_next_to_enemy2):
		dialog_timer += 1
		if (dialog_timer > 800 && dialog_timer < 950):
			$Label6.visible = true
		elif (dialog_timer > 950 && dialog_timer < 1100):
			$Label6.visible = false
			$Label7.visible = true
			
			
func _ready():
	GLOBAL.dialog_counter += 1
	setLimits()
	turn_labels_off()
	
func _physics_process(delta):
	GLOBAL.scene = "house1"
	GLOBAL.sceneScaleCoef = 0.7
	talk_to_daughter()
	talk_to_enemy2()
