extends KinematicBody2D

var velocity = Vector2()
const WALKING_SPEED = 250
const GRAVITY = 20
const CLIMBING_SPEED = 150
const CLIMBING_DURATION = 75
var climbingTimer
var climbingDirection
var isClimbing = false

# sending data to the GLOBAL scope
func globalUpdate():
	GLOBAL.playerCoordinates = position

# walking left and right
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

# falling down
func gravity():
	if is_on_floor():
		velocity.y = 0
	elif !isClimbing:
		velocity.y += GRAVITY

# setting all the parameters that are needed for climbing
func climbingLaunch():
	if (GLOBAL.unableToMoveLeft || GLOBAL.unableToMoveRight) &&\
		Input.is_action_just_pressed("ui_climb") && velocity.y == 0:
			
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
	position.x += climbingDirection * 0.5
	
	if climbingTimer < CLIMBING_DURATION / 2:
		position.y -= 2
		position.x += climbingDirection * 0.5
	
	if climbingTimer < 0:
		isClimbing = false
		$PlayerCollisionShape.disabled = false
			
	climbingTimer -= 1

# main function containing all processes
func _physics_process(delta):
	globalUpdate()
	
	if !isClimbing:	
		movement()
		gravity()
		climbingLaunch()			
	else:	
		climbingProcess()			
	
	move_and_slide(velocity, Vector2(0, -1))