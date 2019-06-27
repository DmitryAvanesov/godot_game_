extends KinematicBody2D

var velocity = Vector2()
const WALKING_SPEED = 250
const GRAVITY = 30
const CLIMBING_SPEED = 150
const CLIMBING_DURATION = 75
var climbingTimer
var climbingDirection
var isClimbing = false
var isSquatting = false
const SQUAT_COEF = 0.3
var curSquatCoef = 1
const LIFT_SPEED = 200
var isUsingLadder = false
var reloadTimer = 120
var ladderTimer = GLOBAL.houseLadderHeight / 2
var ladderDirection


# sending data to the GLOBAL scope
func globalUpdate():
	GLOBAL.playerCoordinates = position
	GLOBAL.player_move_direction = $PlayerSprite.flip_h

# walking left and right
func movement():
	if Input.is_action_pressed("ui_right") && !GLOBAL.unableToMoveRight &&\
	position.x < GLOBAL.rightMoveLimit:
		velocity.x = WALKING_SPEED * GLOBAL.sceneScaleCoef * curSquatCoef
		$PlayerSprite.flip_h = false
		$LightBox.position = Vector2(-5, 10)
		if curSquatCoef == 1:
			$PlayerSprite/AnimationPlayer.play("walking")
		else:
			$PlayerSprite/AnimationPlayer.play("squating")
			
	elif Input.is_action_pressed("ui_left") && !GLOBAL.unableToMoveLeft &&\
	position.x > GLOBAL.leftMoveLimit:
		velocity.x = -WALKING_SPEED * GLOBAL.sceneScaleCoef * curSquatCoef
		$PlayerSprite.flip_h = true
		$LightBox.position = Vector2(35, 10)
		if curSquatCoef == 1:
			$PlayerSprite/AnimationPlayer.play("walking")
		else:
			$PlayerSprite/AnimationPlayer.play("squating")
		
	else:
		velocity.x = 0
		$PlayerSprite/AnimationPlayer.play("standing")

# falling down
func gravity():
	if is_on_floor():
		velocity.y = 0
	elif !isClimbing:
		velocity.y += GRAVITY * GLOBAL.sceneScaleCoef

# setting all the parameters that are needed for climbing
func climbingLaunch():
	if (GLOBAL.unableToMoveLeft || GLOBAL.unableToMoveRight) &&\
		Input.is_action_just_pressed("ui_climb") && velocity.y == 0 && !isSquatting:

			isClimbing = true
			climbingTimer = CLIMBING_DURATION
			$PlayerCollisionShape.disabled = true
			velocity = Vector2(0, 0)
			
			if GLOBAL.unableToMoveRight:
				climbingDirection = 1
				if $PlayerSprite.flip_h == true:
					$PlayerSprite.flip_h = false
			else:
				climbingDirection = -1
				if $PlayerSprite.flip_h == false:
					$PlayerSprite.flip_h = true
					
			$PlayerSprite/AnimationPlayer.play("climbing")
			
# changing player's position while climbing	
func climbingProcess():	
	position.x += climbingDirection * GLOBAL.sceneScaleCoef
	
	if climbingTimer < CLIMBING_DURATION / 2:
		position.y -= 3 * GLOBAL.sceneScaleCoef
		position.x += climbingDirection * GLOBAL.sceneScaleCoef
	
	if climbingTimer < 0:
		isClimbing = false
		$PlayerCollisionShape.disabled = false
			
	climbingTimer -= 1

# squat like a true slav
func squat():
	if Input.is_action_just_pressed("ui_squat"):
		if !isSquatting:
			curSquatCoef = SQUAT_COEF
			isSquatting = true
		else:
			curSquatCoef = 1
			isSquatting = false
		GLOBAL.is_player_squat = isSquatting

# go up the stairs	
func lift():		
	if !isUsingLadder:
		velocity.y = 0
		
		if (Input.is_action_just_pressed("ui_up") && position.y > 0) ||\
		(Input.is_action_just_pressed("ui_down") && position.y < 0):
			isUsingLadder = true
			velocity.x = 0
			position.x = GLOBAL.houseLadderCoordinate
		
			if Input.is_action_just_pressed("ui_up"):
				ladderDirection = 0
			elif Input.is_action_pressed("ui_down"):
				ladderDirection = 1
	else:
		$PlayerSprite/AnimationPlayer.play("usingLadder")
		$PlayerCollisionShape.disabled = true
		
		if ladderDirection == 0:
			velocity.y = -LIFT_SPEED * GLOBAL.sceneScaleCoef
		else:
			velocity.y = LIFT_SPEED * GLOBAL.sceneScaleCoef
		
		
		if ladderTimer == 0:
			isUsingLadder = false
			$PlayerSprite/AnimationPlayer.play("standing")
			ladderTimer = GLOBAL.houseLadderHeight / 2
			$PlayerCollisionShape.disabled = false
			
		ladderTimer -= 1

# get into a shelter		
func hide():
	for i in GLOBAL.shelter_coordinates:
		if (abs(GLOBAL.playerCoordinates.x - i["x"]) < 130 * GLOBAL.sceneScaleCoef &&\
		abs(GLOBAL.playerCoordinates.y - i["y"]) < 130 * GLOBAL.sceneScaleCoef && i["scene"] == GLOBAL.scene):
			if GLOBAL.triggeredEnemies == 0 &&\
			Input.is_action_just_pressed("ui_hide") && !GLOBAL.is_enemy_sees_player &&\
			velocity.x == 0 && velocity.y == 0:
				if !GLOBAL.playerIsHidden:
					GLOBAL.playerIsHidden = true
					$PlayerSprite.visible = false
					$PlayerCollisionShape.disabled = true
				else:
					GLOBAL.playerIsHidden = false
					$PlayerSprite.visible = true
					$PlayerCollisionShape.disabled = false

func goNext():
	if GLOBAL.ableToGoNext && Input.is_action_just_pressed("ui_transit"):
		GLOBAL.is_new_game = true
		get_tree().change_scene(GLOBAL.get_next_scene())

# main function containing all processes
func _physics_process(delta):
	if !GLOBAL.playerIsDead && !GLOBAL.playerIsKilling:
		globalUpdate()
		goNext()
		
		if !isClimbing:
			if !GLOBAL.playerIsHidden:
				if !isUsingLadder:
					movement()
					squat()
					
				if !abs(position.x - GLOBAL.houseLadderCoordinate) < 20:
					gravity()
				else:
					lift()
					
				climbingLaunch()
				
			hide()			
		else:	
			climbingProcess()

		velocity = move_and_slide(velocity, Vector2(0, -1))
	elif GLOBAL.playerIsDead:
		$PlayerSprite/AnimationPlayer.play("dying")
		if reloadTimer == 0:
			GLOBAL.playerIsDead = false
			get_tree().reload_current_scene()
		reloadTimer -= 1
	elif GLOBAL.playerIsKilling:
		$PlayerSprite/AnimationPlayer.play("killing")
		
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