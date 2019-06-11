extends Node

var playerCoordinates = Vector2()
var unableToMoveRight
var unableToMoveLeft
var rightCounter = 0
var leftCounter = 0

func _physics_process(delta):
	if rightCounter > 0:
		unableToMoveRight = true
	else:
		unableToMoveRight = false
		
	if leftCounter > 0:
		unableToMoveLeft = true
	else:
		unableToMoveLeft = false
	
	rightCounter = 0
	leftCounter = 0