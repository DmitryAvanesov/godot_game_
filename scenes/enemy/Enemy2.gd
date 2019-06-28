extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if (abs(GLOBAL.playerCoordinates.x - position.x) < 300 && abs(GLOBAL.playerCoordinates.y - position.y) < 200):
		GLOBAL.is_player_next_to_enemy2 = true
	else:
		GLOBAL.is_player_next_to_enemy2 = false
	$EnemySprite/AnimationEnemy.play("standing")
