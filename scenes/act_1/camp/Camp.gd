extends "res://scenes/act_1/FuncLoadScene.gd"
var n = 2.2
var dialog_timer = 0
var cur_time = 99999999999
var letter_count = 0
# the limits for the current scene	
func setLimits():
	GLOBAL.sceneScaleCoef = $Player.scale.x
	
	$Player/PlayerCamera.limit_top = -900*n
	$Player/PlayerCamera.limit_bottom = 900*n
	
	$Player/PlayerCamera.limit_left = -2100*n
	$Player/PlayerCamera.limit_right = 2100*n
	
	GLOBAL.leftMoveLimit = $Player/PlayerCamera.limit_left + 150
	GLOBAL.rightMoveLimit = $Player/PlayerCamera.limit_right - 150
	
func turn_labels_off():
	$Label1.visible = false
	$Label2.visible = false
	$Label3.visible = false
	$Label4.visible = false
	$Label5.visible = false
#	$Label6.visible = false
#	$Label7.visible = false

func dialog():
	dialog_timer += 1
	if (dialog_timer > 0 && dialog_timer < 150):
		$Label1.visible = true
	elif (dialog_timer > 150 && dialog_timer < 550):
		$Label1.visible = true
	elif (dialog_timer > 550 && dialog_timer < 700):
		$Label1.visible = false
		$Label2.visible = true
		
#	elif (dialog_timer > 350 && dialog_timer < 500):
#		$Label1.visible = false
#		$Label2.visible = true
	
func _ready():
	GLOBAL.dialog_counter += 1
	setLimits()
	turn_labels_off()
func _physics_process(delta):
	GLOBAL.scene = "camp"
	GLOBAL.sceneScaleCoef = 1
	dialog()
	if (abs(GLOBAL.playerCoordinates.x + 1000) < 100 && letter_count == 0):
		cur_time = dialog_timer
		get_node("letter").visible = true
		$Label2.visible = false
		letter_count += 1
	if (dialog_timer > cur_time + 250):
		get_node("letter").visible = false
		$Label3.visible = true
	if (dialog_timer > cur_time + 500):
		$Label3.visible = false
		$Label4.visible = true
	if (dialog_timer > cur_time + 750):
		$Label4.visible = false
		$Label5.visible = true
		GLOBAL.have_been_in_camp = true
	
	
		
		
	