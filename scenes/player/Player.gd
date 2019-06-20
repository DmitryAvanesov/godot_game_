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
const SQUAT_COEF = 0.5
var curSquatCoef = 1
const LIFT_SPEED = 200
var isUsingLadder = false
var leftMoveLimit
var rightMoveLimit


# sending data to the GLOBAL scope
func globalUpdate():
	GLOBAL.playerCoordinates = position

# walking left and right
func movement():
	if Input.is_action_pressed("ui_right") && !GLOBAL.unableToMoveRight &&\
	position.x < rightMoveLimit:
		velocity.x = WALKING_SPEED * GLOBAL.sceneScaleCoef
		$PlayerSprite.flip_h = false
		$LightBox.position = Vector2(-5, 10)
		$PlayerSprite/AnimationPlayer.play("walking")
			
	elif Input.is_action_pressed("ui_left") && !GLOBAL.unableToMoveLeft &&\
	position.x > leftMoveLimit:
		velocity.x = -WALKING_SPEED * GLOBAL.sceneScaleCoef
		$PlayerSprite.flip_h = true
		$LightBox.position = Vector2(35, 10)
		$PlayerSprite/AnimationPlayer.play("walking")
		
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

# squat like a true slav! (todo)
func squat():
	if Input.is_action_just_pressed("ui_squat"):
		if !isSquatting:
			curSquatCoef = SQUAT_COEF
			isSquatting = true
		else:
			curSquatCoef = 1
			isSquatting = false

# go up the stairs	
func lift():		
	if !isUsingLadder:
		velocity.y = 0
		
		if (Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down")):
			isUsingLadder = true
			velocity.x = 0
			position.x = GLOBAL.ladderCoordinates.x
		
			if Input.is_action_just_pressed("ui_up"):
				velocity.y = -LIFT_SPEED * GLOBAL.sceneScaleCoef
			elif Input.is_action_pressed("ui_down"):
				velocity.y = LIFT_SPEED * GLOBAL.sceneScaleCoef
	else:
		$PlayerSprite/AnimationPlayer.play("usingLadder")	
		var gap = GLOBAL.ladderSize * GLOBAL.sceneScaleCoef * 300
		
		if abs(position.y - GLOBAL.ladderCoordinates.y) > gap || is_on_floor():
			isUsingLadder = false
			$PlayerSprite/AnimationPlayer.play("standing")
			
		print(GLOBAL.ladderCoordinates.y)

# get into a shelter		
func hide():
	if GLOBAL.ableToHide && Input.is_action_just_pressed("ui_hide") && velocity.x == 0:
		if !GLOBAL.playerIsHidden:
			GLOBAL.playerIsHidden = true
			$PlayerSprite.visible = false
		else:
			GLOBAL.playerIsHidden = false
			$PlayerSprite.visible = true
			
func goNext():
	if GLOBAL.ableToGoNext && Input.is_action_just_pressed("ui_climb"):
		GLOBAL.is_new_game = true
		get_tree().change_scene(GLOBAL.get_next_scene())

# main function containing all processes
func _physics_process(delta):
	globalUpdate()
	
	if !isClimbing:
		if !GLOBAL.playerIsHidden && !isUsingLadder:
			movement()
			squat()
			
		if !GLOBAL.ableToGoUp:
			gravity()
		else:
			lift()
			
		goNext()
		hide()
		climbingLaunch()			
	else:	
		climbingProcess()			
	
	velocity.x *= curSquatCoef
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