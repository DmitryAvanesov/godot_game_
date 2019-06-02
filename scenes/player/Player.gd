extends KinematicBody2D

var velocity = Vector2()
const SPEED = 400
const GRAVITY = 50
const CLIMBING_SPEED = 30
const CLIMBING_DURATION_UP = 112
const CLIMBING_DURATION_SIDE = 80
var isClimbing = false
var climbingTimerUp
var climbingTimerSide
var climbingDirection

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if !isClimbing:	
		# --- basic movement ---
		
		if Input.is_action_pressed("ui_right"):
			velocity.x = SPEED
			$PlayerAnimatedSprite.flip_h = false
			$PlayerAnimatedSprite.play("walking")
			
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -SPEED
			$PlayerAnimatedSprite.flip_h = true
			$PlayerAnimatedSprite.play("walking")
		
		else:
			velocity.x = 0
			$PlayerAnimatedSprite.play("standing")
			
		# --- gravity ---
		
		if is_on_floor():
			velocity.y = 0
		else:
			velocity.y += GRAVITY
			
		# --- climbing ---
		
		if is_on_wall() && Input.is_action_just_pressed("ui_climb"):
			isClimbing = true
			climbingTimerUp = CLIMBING_DURATION_UP
			climbingTimerSide = CLIMBING_DURATION_SIDE
			if $PlayerAnimatedSprite.flip_h == false:
				climbingDirection = 1
			else:
				climbingDirection = -1
			
	else:
		# --- climbing ---
		
		if climbingTimerUp > 0:			
			climbingTimerUp -= 1
			velocity.x = 0
			velocity.y = -CLIMBING_SPEED
			move_and_slide(velocity)
		else:
			if climbingTimerSide > 0:
				climbingTimerSide -= 1
				velocity.x = climbingDirection * CLIMBING_SPEED
				velocity.y = 0
				move_and_slide(velocity)
			else:
				isClimbing = false