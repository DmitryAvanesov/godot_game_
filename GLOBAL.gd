extends Node

var is_new_game = true
var last_scene ='res://scenes/act_1/preparation_scene/Preparation_scene.tscn'
var haveBeenInHouse = false
var playerCoordinates = Vector2()
var unableToMoveRight
var unableToMoveLeft
var rightCounter = 0
var leftCounter = 0
var ableToGoUp
var goNextCounter = 0
var ableToGoNext
var ladderCounter = 0
var ladderCoordinates
var ladderSize
var ableToHide = false
var shelterCounter = 0
var playerIsHidden = false
const obstacleRects = []
var sceneScaleCoef = 1
var leftMoveLimit
var rightMoveLimit
var triggeredEnemies = 0
var playerIsDead = false
var player_move_direction
var is_player_squat
var is_enemy_sees_player
var playerIsKilling = false

func get_next_scene():	
	var next_scene = ''
	if last_scene == 'res://scenes/act_1/preparation_scene/Preparation_scene.tscn':
		next_scene ='res://scenes/act_1/town/Town.tscn'
		last_scene = next_scene
	elif last_scene == 'res://scenes/act_1/town/Town.tscn' && not haveBeenInHouse:
		next_scene ='res://scenes/act_1/house/House.tscn'
		last_scene = next_scene
		haveBeenInHouse = true
	elif last_scene == 'res://scenes/act_1/house/House.tscn' && haveBeenInHouse:
		next_scene ='res://scenes/act_1/town/Town.tscn'
		last_scene = next_scene
	else: 
		next_scene ='res://scenes/act_1/camp/Camp.tscn'
		last_scene = next_scene
	ableToGoNext = false
	return next_scene

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
	
func interactionsWithGoNext():
	if goNextCounter > 0:
		ableToGoNext = true
	else:
		ableToGoNext = false
	goNextCounter = 0
	
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
	interactionsWithGoNext()