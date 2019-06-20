extends KinematicBody2D

const SPEED = 100
var velocity = Vector2()
const GRAVITY = 30
const JUMP_FORCE = 400
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
var ladderHeight = 0
var shooting_delay = 0
var shot_number = 0
var hit_probability = 0
var max_hit_probability = 0.95
var min_hit_probability = 0.05
var hint
var usingLadder = false
var enemy_pos = Vector2(0, 0)
var vision_sizes

# initial crap
func _ready():
	var node_pos = position
	if (node_pos != null):
		START_ENEMY_POS = node_pos
	
	suspicionsScale.rect_size = Vector2(100, 10)
	suspicionsScale.percent_visible = false
	add_child(suspicionsScale)
	createHint()
	
# create button that you have to press to kill enemy
func createHint():
	hint = Label.new()
	hint.text = "R"
	hint.rect_position = Vector2(30, -$EnemyCollisionShape.shape.extents.y * GLOBAL.sceneScaleCoef * 1)
	hint.rect_scale = Vector2(2 * GLOBAL.sceneScaleCoef, 2 * GLOBAL.sceneScaleCoef)
	add_child(hint)

# moving left and right
func _move(direction, new_speed):
	if (direction == "right") && position.x < GLOBAL.rightMoveLimit:
		velocity.x = new_speed * GLOBAL.sceneScaleCoef
		$EnemySprite.flip_h = false
		$EnemySprite/AnimationEnemy.play("walking")
	elif (direction == "left" && position.x > GLOBAL.leftMoveLimit):
		velocity.x = -new_speed * GLOBAL.sceneScaleCoef
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
		velocity.y += GRAVITY * GLOBAL.sceneScaleCoef
		
# player dies
func die():
	GLOBAL.playerIsDead = true
	if get_node("../Player/PlayerSprite").flip_h == true:
		get_node("../Player").position.x -= 75
	else:
		get_node("../Player").position.x += 75
	
# enemy shoots
func shot():
	$EnemySprite/AnimationEnemy.play("shooting")
	velocity.x = 0
	velocity.y = 0
	
	if shooting_delay == 75:
		var dist = abs(GLOBAL.playerCoordinates.x - position.x)
		var k = shot_number
		
		hit_probability = 30 * k / dist
		if (hit_probability < min_hit_probability):
			hit_probability = min_hit_probability
		if (hit_probability > max_hit_probability):
			hit_probability = max_hit_probability
			
		var rand_number = randf()
		if (rand_number < hit_probability):
			die()

	if shooting_delay == 0:
		shooting_delay = 0
		shooting = false
		
	shooting_delay -= 1

# player kills the enemy
func kill_the_enemy():
	var enemy_dir = $EnemySprite.flip_h
	if (abs(GLOBAL.playerCoordinates.x - position.x) < 100 &&\
	abs(GLOBAL.playerCoordinates.y - position.y) < HEIGHT_GAP && GLOBAL.player_move_direction == enemy_dir) &&\
	!GLOBAL.playerIsHidden:
		get_child(5).visible = true
		if Input.is_key_pressed(KEY_R):
			queue_free()
	else:
		get_child(5).visible = false

# patrolling a territory around a supicious place
func _patrol(pos, new_speed):
	var bump = false
	
	if (position.x == enemy_pos.x):
		bump = true
		
	
	if (abs(GLOBAL.playerCoordinates.x - position.x) < vision_sizes.x / 2 && !GLOBAL.playerIsHidden && abs(GLOBAL.playerCoordinates.y - position.y) < 30):
		if (!GLOBAL.is_player_squat):
			var dist = abs(GLOBAL.playerCoordinates.x - position.x)
			suspicions += 30 * GLOBAL.sceneScaleCoef / dist
	if (suspicions > 60 && abs(GLOBAL.playerCoordinates.x - position.x) < vision_sizes.x / 2 && !GLOBAL.playerIsHidden && abs(GLOBAL.playerCoordinates.y - position.y) < 30):
		if ($EnemySprite.flip_h == true && position.x < GLOBAL.playerCoordinates.x):
			$EnemySprite.flip_h = false
			# playerVisibilityCheck()
		elif ($EnemySprite.flip_h == false && position.x > GLOBAL.playerCoordinates.x):
			$EnemySprite.flip_h = true
			# playerVisibilityCheck()
	else:
		enemy_pos = position
		
		if (enemy_pos.x > pos.x - eps && patrol_direction == false &&\
		enemy_pos.x > GLOBAL.leftMoveLimit && !bump):
			_move("left", new_speed)
		elif enemy_pos.x < pos.x - eps || enemy_pos.x < GLOBAL.leftMoveLimit || bump:
			patrol_direction = true
			_move("right", new_speed)
		
		if(enemy_pos.x < pos.x + eps && patrol_direction == true &&\
		enemy_pos.x < GLOBAL.rightMoveLimit && !bump):
			_move("right", new_speed)
		elif enemy_pos.x > pos.x + eps || enemy_pos.x > GLOBAL.rightMoveLimit || bump:
			patrol_direction = false
			_move("left", new_speed)
	
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
	vision_sizes = $VisionShape.get_shape().extents
	if (abs(GLOBAL.playerCoordinates.x - position.x) < vision_sizes.x / 2 && abs(GLOBAL.playerCoordinates.y - position.y) < 30 * GLOBAL.sceneScaleCoef && suspicions > 60):
		GLOBAL.is_emeny_sees_player = true
	else:
		GLOBAL.is_emeny_sees_player = false;
	
	var shooting_radius = $body/CollisionShape2D.shape.radius
	var player_pos = GLOBAL.playerCoordinates
	var enemy_pos = position
	
	
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
			shot_number = 0
		elif (suspicions > 90):
			if (abs(player_pos.x - enemy_pos.x) < shooting_radius):
				shooting = true
				shot_number += 1
				shooting_delay = 150
		
		if !shooting:
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
				usingLadder = true
		# a player is on the same level
		else:
			if abs(position.x - ladderCoordinate) < 200:
				velocity.y = 0
#			if (suspicions > 60 && abs(GLOBAL.playerCoordinates.x - position.x) < vision_sizes.x / 2):
#				if ($EnemySprite.flip_h == true && position.x < GLOBAL.playerCoordinates.x):
#					$EnemySprite.flip_h = false
#					playerVisibilityCheck()
#				elif ($EnemySprite.flip_h == false && position.x > GLOBAL.playerCoordinates.x):
#					$EnemySprite.flip_h = true
#					playerVisibilityCheck()
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
					elif (abs(enemy_pos.x - START_ENEMY_POS.x) < 30):
						# STAY HERE MOTHERF*CKER that's your home nigga
						_move("stay", SPEED)
						if_enemy_in_start_pos = true
					elif (enemy_pos.x < START_ENEMY_POS.x):
						_move("right", SPEED)
					else:
						_move("left", SPEED)
					
# a scale over an enemy's head				
func visualizeSuspicions():
	if $EnemySprite.flip_h:
		suspicionsScale.rect_position = Vector2(-35, -$EnemySprite.texture.get_size().y *\
		GLOBAL.sceneScaleCoef * 0.12)
	else:
		suspicionsScale.rect_position = Vector2(-60, -$EnemySprite.texture.get_size().y *\
		GLOBAL.sceneScaleCoef * 0.12)
	
	suspicionsScale.value = suspicions

# remembering the ladder that a player used
func checkForLadderUsing():
	if GLOBAL.ableToGoUp && abs(GLOBAL.playerCoordinates.y - position.y) < HEIGHT_GAP:
		ladderCoordinate = GLOBAL.playerCoordinates.x
		
func lift():		
	var gap = GLOBAL.ladderSize * GLOBAL.sceneScaleCoef * 280
	$EnemySprite/AnimationEnemy.play("usingLadder")
	
	print(abs(position.y - GLOBAL.ladderCoordinates.y), " ", gap)
	
	velocity.x = 0
	
	if GLOBAL.playerCoordinates.y > position.y:
		velocity.y = SPEED * GLOBAL.sceneScaleCoef
	else:
		velocity.y = -SPEED * GLOBAL.sceneScaleCoef
	if abs(position.y - GLOBAL.ladderCoordinates.y) > gap:
		usingLadder = false
		$EnemySprite/AnimationEnemy.play("standing")

# main func
func _physics_process(delta):
	if !usingLadder && !shooting:
		gravity()
			
		if (GLOBAL.playerCoordinates.x < position.x && $EnemySprite.flip_h) ||\
		(GLOBAL.playerCoordinates.x > position.x && !$EnemySprite.flip_h):
			lookForPlayer()
		else:
			seesPlayer = false
		
		playerVisibilityCheck()
		visualizeSuspicions()
		checkForLadderUsing()
						
		kill_the_enemy()
	elif usingLadder:
		if (abs(GLOBAL.playerCoordinates.y - position.y) > 30):
			lift()
		else:
			# velocity.y = SPEED
			if (GLOBAL.playerCoordinates.x < position.x):
				_move("left", SPEED * GLOBAL.sceneScaleCoef)
			else:
                _move("right", SPEED * GLOBAL.sceneScaleCoef)
		
		#lift()
	elif shooting:
		shot()
		
	velocity = move_and_slide(velocity, Vector2(0, -1))
	get_node("../Label").text = str(shot_number)
	
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