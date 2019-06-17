extends KinematicBody2D

const SPEED = 100
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
var suspicions = 0
var speed_of_suspicions = 200 # from 0 to 100
var shooting = false
var enemyHeadCoordinates = Vector2()
var playerHeadCoordinates = Vector2()
const HALF_MAN_HEIGHT = 72
var curPoint
var seesPlayer = false
var blockedPoints = 0
const VISIBILITY_STEP = 1
var suspicionsScale = ProgressBar.new()
const HEIGHT_GAP = 200
var ladderCoordinate = 0

# initial crap
func _ready():
	var node_pos = position
	if (node_pos != null):
		START_ENEMY_POS = node_pos
	
	suspicionsScale.rect_size = Vector2(100, 10)
	suspicionsScale.percent_visible = false
	add_child(suspicionsScale)

# moving left and right
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

# jumping over an obstacle	
func jump():
	if is_on_floor():
		velocity.y -= JUMP_FORCE
	else:
		velocity.y += 1

# patrolling a territory around a supicious place
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
	if !seesPlayer:
		if !GLOBAL.playerIsHidden:	
			enemyHeadCoordinates.x = position.x
			enemyHeadCoordinates.y = position.y - HALF_MAN_HEIGHT
			playerHeadCoordinates.x = GLOBAL.playerCoordinates.x
			playerHeadCoordinates.y = GLOBAL.playerCoordinates.y - HALF_MAN_HEIGHT
			
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
		else:
			seesPlayer = false

# FOLLOW THE DAMN PLAYER, ENEMY			
func playerVisibilityCheck():
	if (suspicions > 0):
		suspicions -= 0.01
	else:
		suspicions = 0
	
	var shooting_radius = $body/CollisionShape2D.shape.radius
	var player_pos = GLOBAL.playerCoordinates
	var enemy_pos = position
	
	var vision_sizes = $VisionShape.get_shape().extents
	
	# true - left, false - right
	var direction = $EnemySprite.flip_h
	
	if (((player_pos.x < enemy_pos.x && direction == true) ||\
	(player_pos.x > enemy_pos.x && direction == false)) &&\
	abs(player_pos.x - enemy_pos.x) < vision_sizes.x / 2 &&\
	abs(player_pos.y - enemy_pos.y) < vision_sizes.y / 2) &&\
	seesPlayer && !GLOBAL.playerIsHidden:
		
		if (suspicions < 100):
			suspicions += speed_of_suspicions / abs(player_pos.x - enemy_pos.x)
		elif (suspicions > 100):
			suspicions = 100
			
	#	if (abs(player_pos.x - enemy_pos.x) < shooting_radius):
		if_enemy_in_start_pos = false
		stay = true
		counter_timer_stay = 0
		counter_timer_looking_player = 0
		kind_of_patrol = 1
		lose_sight_of = enemy_pos
		
		if (suspicions > 40 && suspicions < 90):
			shooting = false
		elif (suspicions > 90):
			if (abs(player_pos.x - enemy_pos.x) < shooting_radius):
				shooting = true
			else:
				shooting = false
		
		if abs(GLOBAL.playerCoordinates.y - position.y) < HEIGHT_GAP:
			if (player_pos.x < enemy_pos.x):
				_move("left", SPEED + 50)
			elif (player_pos.x > enemy_pos.x):
				_move("right", SPEED + 50)
		else:
			if (ladderCoordinate < enemy_pos.x):
				_move("left", SPEED + 50)
			elif (ladderCoordinate > enemy_pos.x):
				_move("right", SPEED + 50)
	else:
		# a player is on another level
		if abs(GLOBAL.playerCoordinates.y - position.y) > HEIGHT_GAP && suspicions > 40:
			if (abs(position.x - ladderCoordinate) > 10):
				if (ladderCoordinate < enemy_pos.x):
					_move("left", SPEED + 50)
				elif (ladderCoordinate > enemy_pos.x):
					_move("right", SPEED + 50)
			else:
				useLadder()
		# a player is on the same level
		else:	
			# start position patrol
			if (if_enemy_in_start_pos == true):
				_patrol(START_ENEMY_POS, SPEED)
			else:
				# enemy stopped when he lost player
				if (stay == true && counter_timer_stay < 200):
					_move("stay", 0)
					counter_timer_stay += 1
				elif (stay == true):
					stay = false
				else:
					# enemy patrols (looking for a player)
					if (kind_of_patrol == 1 && lose_sight_of != null && counter_timer_looking_player < 1000):
						_patrol(lose_sight_of, SPEED)
						counter_timer_looking_player += 1
					# enemy goes to the start position
					# OK F*CK GO BACK sad :(
					elif (enemy_pos == START_ENEMY_POS):
						# STAY HERE MOTHERF*CKER
						_move("stay", SPEED)
						if_enemy_in_start_pos = true
					elif (enemy_pos.x < START_ENEMY_POS.x):
						_move("right", SPEED)
					else:
						_move("left", SPEED)	
					
# a scale over an enemy's head				
func visualizeSuspicions():
	if $EnemySprite.flip_h:
		suspicionsScale.rect_position = Vector2(-35, -$EnemySprite.texture.get_size().y * 0.35)
	else:
		suspicionsScale.rect_position = Vector2(-60, -$EnemySprite.texture.get_size().y * 0.35)
	
	suspicionsScale.value = suspicions

# remembering the ladder that a player used
func checkForLadderUsing():
	if GLOBAL.ableToGoUp && abs(GLOBAL.playerCoordinates.y - position.y) < HEIGHT_GAP:
		ladderCoordinate = GLOBAL.playerCoordinates.x

# enemy's getting to another level where a player is
func useLadder():
	var enemyLadderSpeed = GRAVITY * 2
	
	velocity.x = 0
	if abs(GLOBAL.playerCoordinates.y - position.y) > HEIGHT_GAP - $EnemySprite.texture.get_size().y:
		if GLOBAL.playerCoordinates.y > position.y:
			velocity.y = enemyLadderSpeed
		else:
			velocity.y = -enemyLadderSpeed

# main func
func _physics_process(delta):
	gravity()
	
	if is_on_wall():
		jump()
		
	if (GLOBAL.playerCoordinates.x < position.x && $EnemySprite.flip_h) ||\
	(GLOBAL.playerCoordinates.x > position.x && !$EnemySprite.flip_h):
		lookForPlayer()
	else:
		seesPlayer = false
	
	playerVisibilityCheck()
	visualizeSuspicions()
	checkForLadderUsing()
					
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	
func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
#		"attack" : attack,
#		"defense" : defense,
#		"current_health" : current_health,
#		"max_health" : max_health,
#		"damage" : damage,
#		"regen" : regen,
#		"experience" : experience,
#		"tnl" : tnl,
#		"level" : level,
#		"attack_growth" : attack_growth,
#		"defense_growth" : defense_growth,
#		"health_growth" : health_growth,
#		"is_alive" : is_alive,
#		"last_attack" : last_attack
	}
	return save_dict
	
func load_from_dict(save_dict):
	position.y = save_dict['pos_y']
	position.x = save_dict['pos_x']