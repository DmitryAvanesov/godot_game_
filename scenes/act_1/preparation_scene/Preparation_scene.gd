extends "res://scenes/act_1/FuncLoadScene.gd"

var hint

# the limits for the current scene	
func setLimits():
	GLOBAL.sceneScaleCoef = $Player.scale.x
	
	$Player/PlayerCamera.limit_top = -540
	$Player/PlayerCamera.limit_bottom = 540
	
	$Player/PlayerCamera.limit_left = -7400
	$Player/PlayerCamera.limit_right = 2000
	
	GLOBAL.leftMoveLimit = $Player/PlayerCamera.limit_left + 150
	GLOBAL.rightMoveLimit = $Player/PlayerCamera.limit_right - 150
	
	$Enemy.SPEED = 50
	
func createHint():
	hint = Label.new()
	hint.add_color_override("font", Color(0, 0, 0))
	hint.rect_scale = Vector2(2 * GLOBAL.sceneScaleCoef, 2 * GLOBAL.sceneScaleCoef)
	add_child(hint)
	
func updateHint(text):
	hint.text = text
	hint.rect_position = Vector2(GLOBAL.playerCoordinates.x - hint.text.length() * 8,\
	GLOBAL.playerCoordinates.y - 400)
	
func _ready():
	setLimits()
	createHint()

func _physics_process(delta):
	if GLOBAL.playerCoordinates.x < -6000:
		updateHint("Press LEFT and RIGHT to move")
	if GLOBAL.playerCoordinates.x > -6000 && GLOBAL.playerCoordinates.x < -4500:
		updateHint("Press Z to climb")
	if GLOBAL.playerCoordinates.x > -4500 && GLOBAL.playerCoordinates.x < -3000:
		updateHint("Press X to hide in a shelter")
	if GLOBAL.playerCoordinates.x > -3000 && GLOBAL.playerCoordinates.x < -2000:
		updateHint("Press C to squat")
	if GLOBAL.playerCoordinates.x > -2000 && GLOBAL.playerCoordinates.x < 1500:
		updateHint("Press V to kill your enemy from the back")
	if GLOBAL.playerCoordinates.x > 1500:
		updateHint("Press Q to wake up")