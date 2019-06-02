extends KinematicBody2D

# var SPEED = get_node("../Player").SPEED
var SPEED = 100
var velocity = Vector2()
const GRAVITY = 50
var START_ENEMY_POS = null
func _ready():
	var node_pos = get_node("../Enemy").get_position()
	if (node_pos != null):
		START_ENEMY_POS = node_pos
	pass

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2(0, -1))
	var radius = get_node("body/CollisionShape2D").shape.radius
	var player_pos = get_node("../Player").get_position()
	var enemy_pos = get_node("../Enemy").get_position()
	# FOLLOW THE DAMN PLAYER, ENEMY
	if (abs(player_pos.x - enemy_pos.x) < radius):
		if (player_pos.x < enemy_pos.x):
			velocity.x = -SPEED
		elif (player_pos.x > enemy_pos.x):
			velocity.x = SPEED
	# OK FUCK GO BACK
	else:
		if (enemy_pos == START_ENEMY_POS):
			# STAY HERE MOTHERFUCKER
			velocity.x = 0
		elif (enemy_pos < START_ENEMY_POS):
			velocity.x = SPEED
		else:
			velocity.x = -SPEED
		
	
	#if is_on_floor():
	#	velocity.y = 0
	#else:
	#	velocity.y += GRAVITY