extends "res://scenes/act_1/FuncLoadScene.gd"

var dialog_timer = 0

func turn_labels_off():
	$Label1.visible = false
	$Label2.visible = false
#	$Label3.visible = false
#	$Label4.visible = false
#	$Label5.visible = false
#	$Label6.visible = false
#	$Label7.visible = false
#	$Label8.visible = false
	
# the limits for the current scene	
func setLimits():
	GLOBAL.sceneScaleCoef = $Player.scale.x
	
	$Player/PlayerCamera.limit_top = -540
	$Player/PlayerCamera.limit_bottom = 540
	
	$Player/PlayerCamera.limit_left = -1080
	$Player/PlayerCamera.limit_right = 1080
	
	GLOBAL.leftMoveLimit = $Player/PlayerCamera.limit_left + 150
	GLOBAL.rightMoveLimit = $Player/PlayerCamera.limit_right - 150
	
func dialog():
	dialog_timer += 1
	if (dialog_timer > 0 && dialog_timer < 250):
		$Label1.visible = true
	else:
		$Label1.visible = false
		
	if (GLOBAL.enemy_killed_house2):
		$Label2.visible = true
#	elif (dialog_timer >= 100 && dialog_timer < 300):
#		$Label1.visible = false
#		$Label2.visible = true
#	elif (dialog_timer >= 300 && dialog_timer < 500):
#		$Label2.visible = false
#		$Label3.visible = true
#	elif (dialog_timer >= 500 && dialog_timer < 600):
#		$Label3.visible = false
#		$Label4.visible = true
#	elif (dialog_timer >= 600 && dialog_timer < 700):
#		$Label4.visible = false
#		$Label5.visible = true
#	elif (dialog_timer > 700):
#		$Label5.visible = false
#		$Enemy.visible = true
	
func _ready():
	GLOBAL.dialog_counter += 1
	turn_labels_off()
	setLimits()
	
func _physics_process(delta):
	GLOBAL.scene = "house2"
	GLOBAL.sceneScaleCoef = 0.7
	dialog()
	