extends Node

var is_new_game = true
var last_scene ='res://scenes/act_1/preparation_scene/Preparation_scene.tscn'
var haveBeenInHouse = false
var playerCoordinates = Vector2()
var unableToMoveRight
var unableToMoveLeft
var rightCounter = 0
var leftCounter = 0
var goNextCounter = 0
var ableToGoNext
var ladderCounter = 0
var ladderCoordinates
var ladderSize
# var ableToHide = false
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
var houseLadderCoordinate = 705
var houseLadderHeight = 480
var scene
var dialog_counter = 0
var is_player_moving = false
var talked_to_daughter = false
var is_player_next_to_enemy2 = false
var have_been_in_camp = false
var shelter_coordinates = [{
	"scene" : "house2",
	"x" : 310,
	"y" : 300	
},{
	"scene" : "house2",
	"x" : -302,
	"y" : -228	
},{
	"scene" : "house2",
	"x" : 310,
	"y" : 300
},{
	"scene" : "house2",
	"x" : -302,
	"y" : -228	
},{
	"scene" : "town3",
	"x" : 42,
	"y" : 330	
},{
	"scene" : "town3",
	"x" : 1245,
	"y" : 330	
},{
	"scene" : "town3",
	"x" : 1710,
	"y" : 330	
},{
	"scene" : "camp",
	"x" : 1254,
	"y" : 1630	
},{
	"scene" : "preparation",
	"x" : -3619,
	"y" : 92	
}
]
var obstacle_coordinates = [{
	"scene" : "house2",
	"x" : 160,
	"y" : -100	
},{
	"scene" : "house2",
	"x" : -290,
	"y" : 442
}
]

func get_next_scene():	
	var next_scene = ''
	if last_scene == 'res://scenes/act_1/preparation_scene/Preparation_scene.tscn':
		next_scene ='res://scenes/act_1/town/Town1.tscn'
		last_scene = next_scene
	elif last_scene == 'res://scenes/act_1/town/Town1.tscn' && not haveBeenInHouse:
		next_scene ='res://scenes/act_1/house/House1.tscn'
		last_scene = next_scene
		haveBeenInHouse = true
	elif last_scene == 'res://scenes/act_1/house/House1.tscn' && haveBeenInHouse:
		next_scene ='res://scenes/act_1/town/Town2.tscn'
		last_scene = next_scene
	elif last_scene == 'res://scenes/act_1/town/Town2.tscn': 
		next_scene ='res://scenes/act_1/camp/Camp.tscn'
		last_scene = next_scene
	elif last_scene == 'res://scenes/act_1/camp/Camp.tscn' && have_been_in_camp: 
		print("yes")
		next_scene ='res://scenes/act_1/town/Town3.tscn'
		last_scene = next_scene
	elif last_scene == 'res://scenes/act_1/camp/Town3.tscn' && have_been_in_camp: 
		print("yes")
		next_scene ='res://scenes/act_1/town/House2.tscn'
		last_scene = next_scene
	else: 
		next_scene ='res://scenes/act_1/town/Town4.tscn'
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
	
func interactionsWithGoNext():
	if goNextCounter > 0:
		ableToGoNext = true
	else:
		ableToGoNext = false
	goNextCounter = 0
	
#func interactionsWithShelters():
#	if shelterCounter > 0:
#		ableToHide = true
#	else:
#		ableToHide = false
#
#	shelterCounter = 0

func _physics_process(delta):
	interactionsWithObstacles()
	# interactionsWithShelters()
	interactionsWithGoNext()