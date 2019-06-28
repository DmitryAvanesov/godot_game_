extends Node2D

var dialog_timer = 0
func setLimits():
	GLOBAL.sceneScaleCoef = $Player.scale.x
	
	$Player/PlayerCamera.limit_top = -540
	$Player/PlayerCamera.limit_bottom = 540
	
	$Player/PlayerCamera.limit_left = -2000
	$Player/PlayerCamera.limit_right = 2000
	
	GLOBAL.leftMoveLimit = $Player/PlayerCamera.limit_left + 50
	GLOBAL.rightMoveLimit = $Player/PlayerCamera.limit_right - 50
	
	if GLOBAL.haveBeenInHouse:
		$To_next_location.position = Vector2(1840, 300)
		if GLOBAL.is_new_game:
			$Player.position = Vector2(600, 340)


func turn_labels_off():
	$Label1.visible = false
	$Label2.visible = false
#	$Label3.visible = false
#	$Label4.visible = false
#	$Label5.visible = false
#	$Label6.visible = false
#	$Label7.visible = false

func dialog():
	if (GLOBAL.is_player_moving && !$Player/PlayerSprite.flip_h):
		dialog_timer += 1
	if (dialog_timer > 200 && dialog_timer < 350):
		$Label1.visible = true
	elif (dialog_timer > 350 && dialog_timer < 500):
		$Label1.visible = false
		$Label2.visible = true

func _ready():
	setLimits()
	turn_labels_off()
	pass # Replace with function body.

func _physics_process(delta):
	dialog()
	pass
