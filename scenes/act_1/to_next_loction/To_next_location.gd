extends Area2D

var gap = 100 * GLOBAL.sceneScaleCoef
var hint
func createHint():
	hint = Label.new()
	hint.text = "Q"
	hint.rect_position = Vector2(0, -200)
	hint.rect_scale = Vector2(2 * GLOBAL.sceneScaleCoef, 2 * GLOBAL.sceneScaleCoef)
	add_child(hint)

# shows or hides the button you need to press to climb
func showHideHint():
	var distancex = abs(GLOBAL.playerCoordinates.x - position.x)
	var distancey = abs(GLOBAL.playerCoordinates.y - position.y)
	if distancex < 100 && distancey < 200:
		get_child(1).visible = true
	else:
		get_child(1).visible = false

# initial stuff
func _ready():
	createHint()

func _physics_process(delta):
	if abs(GLOBAL.playerCoordinates.x - position.x) < gap * scale.x &&\
	abs(GLOBAL.playerCoordinates.y - position.y) < gap * scale.y * 4.5:
		GLOBAL.goNextCounter += 1
	showHideHint()