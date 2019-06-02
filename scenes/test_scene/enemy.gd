extends KinematicBody2D

# var SPEED = get_node("../Player").SPEED
var SPEED = 100
var velocity = Vector2()
const GRAVITY = 50
func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2(0, -1))
	var radius = get_node("body/CollisionShape2D").shape.radius
	var player_pos = get_node("../Player").get_position()
	var enemy_pos = get_node("../enemy").get_position()
	if (abs(player_pos.x - enemy_pos.x) < radius):
		if (player_pos.x < enemy_pos.x):
			#print("go left")
			velocity.x = -SPEED
		elif (player_pos.x > enemy_pos.x):
			#print("go right")
			velocity.x = SPEED
	else:
		velocity.x = 0
	
#	if is_on_floor():
#		velocity.y = 0
#	else:
#		velocity.y += GRAVITY