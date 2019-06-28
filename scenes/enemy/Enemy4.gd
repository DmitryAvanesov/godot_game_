extends KinematicBody2D

var SPEED = 250
var velocity = Vector2()
const GRAVITY = 30
const JUMP_FORCE = 400
var eps = 400 * GLOBAL.sceneScaleCoef
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
var HALF_MAN_HEIGHT = 432 * scale.y
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
var isDead = false
var dieTimer = 160
var isClimbing = false
var climbingDirection
const CLIMBING_DURATION = 75
var climbingTimer
var dialog_timer = 0

# initial crap
func _ready():
	var node_pos = position
	if (node_pos != null):
		START_ENEMY_POS = node_pos
	
	suspicionsScale.rect_size = Vector2(100, 10)
	suspicionsScale.percent_visible = false
	# $EnemyCollisionShape.disabled = true

# moving left and right
func _move(direction, new_speed):
	if (direction == "right") && position.x < GLOBAL.rightMoveLimit:
		$LightBox.position = Vector2(0, 10)
		velocity.x = new_speed * GLOBAL.sceneScaleCoef
		$EnemySprite.flip_h = false
		$EnemySprite/AnimationEnemy.play("walking")
	elif (direction == "left" && position.x > GLOBAL.leftMoveLimit):
		$LightBox.position = Vector2(35, 10)
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
	GLOBAL.dialog_counter -= 1
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
	if (abs(GLOBAL.playerCoordinates.x - position.x) < 200 * GLOBAL.sceneScaleCoef &&\
	abs(GLOBAL.playerCoordinates.y - position.y) < HEIGHT_GAP && GLOBAL.player_move_direction == enemy_dir) &&\
	!GLOBAL.playerIsHidden:
		get_child(6).visible = true
		if Input.is_action_just_pressed("ui_kill"):
			isDead = true
			GLOBAL.playerIsKilling = true
	else:
		get_child(6).visible = false

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
	if (abs(GLOBAL.playerCoordinates.x - position.x) < vision_sizes.x / 2 &&\
	abs(GLOBAL.playerCoordinates.y - position.y) < 30 * GLOBAL.sceneScaleCoef && suspicions > 60):
		GLOBAL.is_enemy_sees_player = true
	else:
		GLOBAL.is_enemy_sees_player = false
	
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
					# STAY HERE MOTHERF*CKER that's your home n*gga
					_move("stay", SPEED)
					if_enemy_in_start_pos = true
				elif (enemy_pos.x < START_ENEMY_POS.x):
					_move("right", SPEED)
				else:
					_move("left", SPEED)
					
# a scale over an enemy's head				
	
func climbingLaunch():	
	for i in GLOBAL.obstacle_coordinates:		
		if ((position.x - i["x"] > 0 && position.x - i["x"] < 125 * GLOBAL.sceneScaleCoef &&\
		$EnemySprite.flip_h) || (position.x - i["x"] > -125 * GLOBAL.sceneScaleCoef &&\
		position.x - i["x"] < 0 && !$EnemySprite.flip_h)) &&\
		abs(position.y - i["y"]) < 200 * GLOBAL.sceneScaleCoef && i["scene"] == GLOBAL.scene:
			print(abs(position.y - i["y"]))
				
			isClimbing = true
			climbingTimer = CLIMBING_DURATION
			$EnemyCollisionShape.disabled = true
			velocity = Vector2(0, 0)
			
			if $EnemySprite.flip_h:
				climbingDirection = -1
			else:
				climbingDirection = 1
				
			$EnemySprite/AnimationEnemy.play("climbing")
			
func climbingProcess():
	position.x += climbingDirection * GLOBAL.sceneScaleCoef
	
	if climbingTimer < CLIMBING_DURATION / 2:
		position.y -= 3 * GLOBAL.sceneScaleCoef
		position.x += climbingDirection * GLOBAL.sceneScaleCoef
	
	if climbingTimer < 0:
		isClimbing = false
		$EnemyCollisionShape.disabled = false
			
	climbingTimer -= 1

# main func
func _physics_process(delta):
	dialog_timer += 1
	if !isDead:
		if !shooting:
			if !isClimbing:
				gravity()
				
				climbingLaunch()
			else:
				climbingProcess()
			if (dialog_timer < 250):
				_move("stand", SPEED)
				$EnemySprite.flip_h = true
			if (dialog_timer > 250 && dialog_timer < 550):
				_move("right", SPEED)
			elif (dialog_timer > 550 && dialog_timer < 750):
				_move("stand", SPEED)
				$EnemySprite.flip_h = true
			elif (dialog_timer > 750 && dialog_timer < 1500):
				_move("right", SPEED)
#			elif (dialog_timer > 1500 && dialog_timer < 1750):
#				_move("left", SPEED)
			else:
				_move("stand", SPEED)
				$EnemySprite.flip_h = true
				
			
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