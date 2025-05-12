extends CharacterBody2D

#Constants
const speed = 200.0
const jumpVelocity = -400.0
const gravity = 1000.0

#Main Physics
func _physics_process(delta: float) -> void:
	var direction = 0
	
	#Left / Right Input
	if Input.is_action_pressed("ui_left"):
		direction -= 1
	if Input.is_action_pressed("ui_right"):
		direction += 1
	
	#Apply horizontal movement
	velocity.x = direction * speed
	
	#Apply Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if Input.is_action_pressed("ui_accept"):
			velocity.y += jumpVelocity
		
	#Move the character
	move_and_slide()
