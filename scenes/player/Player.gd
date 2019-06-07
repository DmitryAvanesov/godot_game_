extends KinematicBody2D

var velocity = Vector2()
const WALKING_SPEED = 250
const GRAVITY = 20
const CLIMBING_SPEED_UP = 200
const CLIMBING_SPEED_SIDE = 100
const CLIMBING_DURATION_UP = 35
const CLIMBING_DURATION_SIDE = 15
var isClimbing = false
var climbingTimerUp
var climbingTimerSide
var climbingDirection

func globalUpdate():
	GLOBAL.playerCoordinates = position
	
func movement():	
	if Input.is_action_pressed("ui_right") && !GLOBAL.unableToMoveRight:
		velocity.x = WALKING_SPEED
		$PlayerSprite.flip_h = false
		$PlayerSprite/AnimationPlayer.play("walking")
			
	elif Input.is_action_pressed("ui_left") && !GLOBAL.unableToMoveLeft:
		velocity.x = -WALKING_SPEED
		$PlayerSprite.flip_h = true
		$PlayerSprite/AnimationPlayer.play("walking")
		
	else:
		velocity.x = 0
		$PlayerSprite/AnimationPlayer.play("standing")
		
func gravity():
	if is_on_floor():
		velocity.y = 0
	elif !isClimbing:
		velocity.y += GRAVITY

func _physics_process(delta):	
	globalUpdate()
	
	if !isClimbing:	
		movement()
		gravity()
			
		# --- climbing ---
		
		if (GLOBAL.unableToMoveLeft || GLOBAL.unableToMoveRight) &&\
		Input.is_action_just_pressed("ui_climb"):
			
			isClimbing = true
			climbingTimerUp = CLIMBING_DURATION_UP
			climbingTimerSide = CLIMBING_DURATION_SIDE
			if GLOBAL.unableToMoveRight:
				climbingDirection = 1
			else:
				climbingDirection = -1
			$PlayerSprite/AnimationPlayer.play("climbing")
			
	else:
		# --- climbing ---
		
		if climbingTimerUp > 0:			
			climbingTimerUp -= 1
			velocity.x = 0
			velocity.y = -CLIMBING_SPEED_UP
		elif climbingTimerSide > 0:
			climbingTimerSide -= 1
			velocity.x = climbingDirection * CLIMBING_SPEED_SIDE
			velocity.y = 0
		else:
			isClimbing = false
	
	move_and_slide(velocity, Vector2(0, -1))