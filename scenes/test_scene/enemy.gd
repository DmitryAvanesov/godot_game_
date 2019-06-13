extends KinematicBody2D

var SPEED = 100
var velocity = Vector2()
const GRAVITY = 50
const JUMP_FORCE = 700
var eps = 300
var START_ENEMY_POS = null
var lose_sight_of = null
var patrol_direction = false
var kind_of_patrol = 0
var counter_timer_looking_player = 0
var counter_timer_stay = 0
var stay = true
var if_enemy_in_start_pos = true
var enemyHeadCoordinates = Vector2()
var playerHeadCoordinates = Vector2()
const halfManHeight = 72
var curPoint
var seesPlayer = false
var blockedPoints = 0
const VISIBILITY_STEP = 1


func _ready():
	var node_pos = position
	if (node_pos != null):
		START_ENEMY_POS = node_pos
	pass

func _move(direction, new_speed):
	if (direction == "right"):
		velocity.x = new_speed
		$EnemySprite.flip_h = false
		$EnemySprite/AnimationEnemy.play("walking")
	elif (direction == "left"):
		velocity.x = -new_speed
		$EnemySprite.flip_h = true
		$EnemySprite/AnimationEnemy.play("walking")
	else:
		velocity.x = 0
		$EnemySprite/AnimationEnemy.play("standing")
		
# falling down
func gravity():
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += GRAVITY

# jumps when bumps into an obstacle		
func jump():
	if is_on_floor():
		velocity.y -= JUMP_FORCE
	else:
		velocity.y += 1

func _patrol(pos, new_speed):
	var enemy_pos = position
	if (enemy_pos.x > pos.x - eps && patrol_direction == false):
		_move("left", new_speed)
	elif (enemy_pos.x < pos.x - eps):
		patrol_direction = true
	if(enemy_pos.x < pos.x + eps && patrol_direction == true):
		_move("right", new_speed)
	elif (enemy_pos.x > pos.x + eps):
		patrol_direction = false
		
# checking if our player is visible to the enemy
func lookForPlayer():
	enemyHeadCoordinates.x = position.x
	enemyHeadCoordinates.y = position.y - halfManHeight	
	playerHeadCoordinates.x = GLOBAL.playerCoordinates.x
	playerHeadCoordinates.y = GLOBAL.playerCoordinates.y - halfManHeight
	
	var k
	var b
	
	k = (enemyHeadCoordinates.y - playerHeadCoordinates.y) /\
	(enemyHeadCoordinates.x - playerHeadCoordinates.x)
	
	b = (playerHeadCoordinates.x * enemyHeadCoordinates.y -\
	enemyHeadCoordinates.x * playerHeadCoordinates.y) /\
	(playerHeadCoordinates.x - enemyHeadCoordinates.x)
	
	var beg
	var end
	
	if playerHeadCoordinates.x < enemyHeadCoordinates.x:
		beg = playerHeadCoordinates.x
		end = enemyHeadCoordinates.x
	else:
		beg = enemyHeadCoordinates.x
		end = playerHeadCoordinates.x
		
	blockedPoints = 0
		
	while beg < end:
		curPoint = Vector2(beg, k * beg + b)

		for rect in GLOBAL.obstacleRects:
			if rect.has_point(curPoint):
				blockedPoints += 1
				break
				
		beg += VISIBILITY_STEP
		
	if blockedPoints == 0:
		seesPlayer = true
	else:
		seesPlayer = false
	

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2(0, -1))
	var radius = get_node("body/CollisionShape2D").shape.radius
	var player_pos = get_node("../Player").get_position()
	var enemy_pos = position
	
	gravity()	
	if is_on_wall():
		jump()
	
	if (GLOBAL.playerCoordinates.x < position.x && $EnemySprite.flip_h) ||\
	(GLOBAL.playerCoordinates.x > position.x && !$EnemySprite.flip_h):
		lookForPlayer()
	else:
		seesPlayer = false
		
	print(seesPlayer)
	
	# FOLLOW THE DAMN PLAYER, ENEMY
	if (abs(player_pos.x - enemy_pos.x) < radius):
		if_enemy_in_start_pos = false
		stay = true
		counter_timer_stay = 0
		counter_timer_looking_player = 0
		kind_of_patrol = 1
		lose_sight_of = enemy_pos
		if (player_pos.x < enemy_pos.x):
			_move("left", SPEED)
		elif (player_pos.x > enemy_pos.x):
			_move("right", SPEED)
	
	else:		
		# start position patrol
		if (if_enemy_in_start_pos == true):
			_patrol(START_ENEMY_POS, SPEED)
			print("we are here")
		else:
			# enemy stopped when he lost player
			if (stay == true && counter_timer_stay < 200):
				_move("left", 0)
				counter_timer_stay += 1
			elif (stay == true):
				stay = false
			else:
				# enemy patrols (looking for a player)
				if (kind_of_patrol == 1 && lose_sight_of != null && counter_timer_looking_player < 1000):
					_patrol(lose_sight_of, SPEED)
					counter_timer_looking_player += 1
					
				# enemy goes to the start position
				# OK FUCK GO BACK sad :(
				elif (enemy_pos == START_ENEMY_POS):
					# STAY HERE MOTHERFUCKER
					_move("stay", SPEED)
					if_enemy_in_start_pos = true
				elif (enemy_pos.x < START_ENEMY_POS.x):
					_move("right", SPEED)
				else:
					_move("left", SPEED)