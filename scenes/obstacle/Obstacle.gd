extends Sprite

const gap = 75
var distance
var heightDifference
var hint

# shows a player what button to press
func createHint():
	hint = Label.new()
	hint.text = "E"
	hint.rect_position = Vector2(0, -150)
	hint.rect_scale = Vector2(3, 3)
	add_child(hint)

# doesn't allow a player to bump into the obstacle
func catchCollisions():
	if distance > 0 && distance < gap && heightDifference < gap * 2:
		GLOBAL.rightCounter += 1
		
	if distance < 0 && distance > -gap && heightDifference < gap * 2:
		GLOBAL.leftCounter += 1

# shows or hides the button you need to press to climb	
func showHideHint():
	if abs(distance) < gap && heightDifference < gap * 1.5:
		get_child(1).visible = true
	else:
		get_child(1).visible = false
		
# initial stuff
func _ready():
	createHint()

# main processes
func _physics_process(delta):
	distance = position.x - GLOBAL.playerCoordinates.x
	heightDifference = abs(position.y - GLOBAL.playerCoordinates.y)
	
	catchCollisions()
	showHideHint()