extends Node

var is_new_game = false
var playerCoordinates = Vector2()
var unableToMoveRight
var unableToMoveLeft
var rightCounter = 0
var leftCounter = 0
var ableToGoUp
var ladderCounter = 0
var ladderCoordinates
var ladderSize
var ableToHide
var shelterCounter = 0
var playerIsHidden = false
const obstacleRects = []
var sceneScaleCoef = 1
var leftMoveLimit
var rightMoveLimit
var triggeredEnemies = 0
var playerIsDead = false
var player_move_direction

func interactionsWithObstacles():
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
	
func interactionsWithLadders():
	if ladderCounter > 0:
		ableToGoUp = true
	else:
		ableToGoUp = false
		
	ladderCounter = 0
	
func interactionsWithShelters():
	if shelterCounter > 0:
		ableToHide = true
	else:
		ableToHide = false
		
	shelterCounter = 0

func _physics_process(delta):	
	interactionsWithObstacles()
	interactionsWithLadders()
	interactionsWithShelters()