extends KinematicBody2D

var velocity = Vector2()
var tmpVelocity
const WALKING_SPEED = 300
const GRAVITY = 20
const CLIMBING_SPEED_UP = 200
const CLIMBING_SPEED_SIDE = 100
const CLIMBING_DURATION_UP = 35
const CLIMBING_DURATION_SIDE = 15
var isClimbing = false
var climbingTimerUp
var climbingTimerSide
var climbingDirection

func _physics_process(delta):
	if !isClimbing:	
		# --- basic movement ---
		
		if Input.is_action_pressed("ui_right") && !is_on_wall():
			velocity.x = 1
			$PlayerSprite.flip_h = false
			$PlayerSprite/AnimationPlayer.play("walking")
			
		elif Input.is_action_pressed("ui_left") && !is_on_wall():
			velocity.x = -1
			$PlayerSprite.flip_h = true
			$PlayerSprite/AnimationPlayer.play("walking")
		
		else:
			velocity.x = 0
			$PlayerSprite/AnimationPlayer.play("standing")
			
		# --- gravity ---
		
		if is_on_floor():
			velocity.y = 0
		elif !isClimbing:
			velocity.y += 1
			
		# --- climbing ---
		
		if is_on_wall() && Input.is_action_just_pressed("ui_climb"):
			isClimbing = true
			climbingTimerUp = CLIMBING_DURATION_UP
			climbingTimerSide = CLIMBING_DURATION_SIDE
			if $PlayerSprite.flip_h == false:
				climbingDirection = 1
			else:
				climbingDirection = -1
			
	else:
		# --- climbing ---
		
		if climbingTimerUp > 0:			
			climbingTimerUp -= 1
			velocity.x = 0
			velocity.y = -1
		elif climbingTimerSide > 0:
			climbingTimerSide -= 1
			velocity.x = climbingDirection
			velocity.y = 0
		else:
			isClimbing = false
	
	# --- movement itself ---
	
	tmpVelocity = velocity
	tmpVelocity.y = 0
	for i in range(WALKING_SPEED):
		move_and_slide(tmpVelocity, Vector2(0, -1))
	
	if isClimbing:
		if climbingTimerUp > 0:
			tmpVelocity = velocity
			tmpVelocity.x = 0
			for i in range(CLIMBING_SPEED_UP):
				move_and_slide(tmpVelocity, Vector2(0, -1))
		else:
			tmpVelocity = velocity
			tmpVelocity.y = 0
			for i in range(CLIMBING_SPEED_SIDE):
				move_and_slide(tmpVelocity, Vector2(0, -1))
	else:
		tmpVelocity = velocity
		tmpVelocity.x = 0
		for i in range(GRAVITY):
			move_and_slide(tmpVelocity, Vector2(0, -1))