extends KinematicBody2D

var velocity = Vector2()
const SPEED = 400
const GRAVITY = 50

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	# --- basic movement ---
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		$PlayerSprite.flip_h = false
		
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		$PlayerSprite.flip_h = true
	
	else:
		velocity.x = 0
		
	# --- gravity ---
	
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += GRAVITY