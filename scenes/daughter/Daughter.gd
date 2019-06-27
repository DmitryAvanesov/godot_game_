extends KinematicBody2D

const SPEED = 100
const GRAVITY = 30
const movementCycle = 1000
var movementTimer = movementCycle
var velocity = Vector2(0, 0)

# falling down
func gravity():
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += GRAVITY

# move
func movement():
	$DaughterSprite/AnimationDaughter.play("walking")
	
	if movementTimer > movementCycle * 1/2:
		$DaughterSprite.flip_h = false
		velocity.x = SPEED
	else:
		$DaughterSprite.flip_h = true
		velocity.x = -SPEED
		
func behavior():
	if abs(GLOBAL.playerCoordinates.y - position.y) < 100 &&\
	abs(GLOBAL.playerCoordinates.x - position.x) < 200:
		velocity.x = 0
		$DaughterSprite/AnimationDaughter.play("standing")
		
		GLOBAL.talked_to_daughter = true
		
		if GLOBAL.playerCoordinates.x - position.x > 0:
			$DaughterSprite.flip_h = false
		else:
			$DaughterSprite.flip_h = true
	else:
		if movementTimer > movementCycle * 3/4 ||\
		(movementTimer > movementCycle * 1/4 && movementTimer < movementCycle * 1/2):
			velocity.x = 0
			$DaughterSprite/AnimationDaughter.play("standing")
		else:
			movement()
	
	movementTimer -= 1
	if movementTimer == 0:
		movementTimer = movementCycle

# main
func _physics_process(delta):
	gravity()
	behavior()
	
	velocity = move_and_slide(velocity, Vector2(0, -1))