extends Sprite

const GAP = 25
var distance
var heightDifference
var hint

# shows a player what button to press
func createHint():
	hint = Label.new()
	hint.text = "D"
	hint.rect_position = Vector2(0, -texture.get_size().y * 0.9)
	hint.rect_scale = Vector2(2, 2)
	add_child(hint)

# shows or hides the button you need to press to climb	
func showHideHint():
	if distance < GAP && heightDifference < GAP * 1.5:
		get_child(0).visible = true
	else:
		get_child(0).visible = false

# initial stuff		
func _ready():
	createHint()

# check if a player can hide in this very shelter
func checkHidingAbility():
	if abs(GLOBAL.playerCoordinates.x - position.x) < GAP &&\
	abs(GLOBAL.playerCoordinates.y - position.y) < GAP * 2:
		GLOBAL.shelterCounter += 1

# kinda main function
func _physics_process(delta):
	distance = abs(position.x - GLOBAL.playerCoordinates.x)
	heightDifference = abs(position.y - GLOBAL.playerCoordinates.y)
	
	checkHidingAbility()
	showHideHint()