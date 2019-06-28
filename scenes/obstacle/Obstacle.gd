extends Sprite

var gap
var distance
var heightDifference
var hint
var rectCoordinates = Vector2()
var rectSize = Vector2()

# shows a player what button to press
func createHint():
	hint = Label.new()
	hint.text = "Z"
	hint.rect_position = Vector2(0, -1500)
	hint.rect_scale = Vector2(35 * GLOBAL.sceneScaleCoef, 35 * GLOBAL.sceneScaleCoef)
	add_child(hint)

# doesn't allow a player to bump into the obstacle
func catchCollisions():
	if distance > 0 && distance < gap && heightDifference < gap * 1.5:
		GLOBAL.rightCounter += 1
		
	if distance < 0 && distance > -gap && heightDifference < gap * 1.5:
		GLOBAL.leftCounter += 1

# shows or hides the button you need to press to climb	
func showHideHint():
	if abs(distance) < gap && heightDifference < gap * 1.5:
		get_child(1).visible = true
	else:
		get_child(1).visible = false

# appending the obstacle's coordinates and size to the array in GLOBAL	
func setRect():
	rectCoordinates.x = position.x - texture.get_size().x * scale.x / 2
	rectCoordinates.y = position.y - texture.get_size().y * scale.y / 2
	rectSize.x = texture.get_size().x * scale.x
	rectSize.y = texture.get_size().y * scale.y
	GLOBAL.obstacleRects.append(Rect2(rectCoordinates, rectSize))
		
# initial stuff
func _ready():
	createHint()
	setRect()

# main processes
func _physics_process(delta):
	distance = position.x - GLOBAL.playerCoordinates.x
	heightDifference = abs(position.y - GLOBAL.playerCoordinates.y)
	gap = 125 * GLOBAL.sceneScaleCoef
	
	catchCollisions()
	showHideHint()