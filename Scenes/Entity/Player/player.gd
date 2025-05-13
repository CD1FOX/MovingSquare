extends CharacterBody2D

#Constants
const normalSpeed = 200.0
const sprintSpeed = 350.0
const jumpVelocity = -400.0
const gravity = 1000.0
const dashSpeed = 1000.0
const dashDuration = 0.2
const dashCooldown = 1.0
const maxJump = 2

#variables
var dashTimer = 0.0
var dashCooldownTimer = 0.0
var isDashing = false
var dashDirection = 0
var jumpCount = 0


#Main Physics
func _physics_process(delta: float) -> void:
	var direction = 0
	var speed = normalSpeed
	
	#Left / Right Input
	if Input.is_action_pressed("ui_left"):
		direction -= 1
	if Input.is_action_pressed("ui_right"):
		direction += 1
		
	#Sprinting
	if Input.is_action_pressed("Sprint") and not isDashing:
		speed = sprintSpeed
	
	#Dash Input
	if Input.is_action_just_pressed("Dash") and not isDashing and dashCooldownTimer <= 0:
		isDashing = true
		dashTimer = dashDuration
		dashDirection = direction if direction != 0 else sign(velocity.x)
		dashCooldownTimer = dashCooldown
	
	#Handles Dash
	if isDashing:
		velocity.x = dashDirection * dashSpeed
		dashTimer -= delta
		if dashTimer <= 0:
			isDashing = false
	else:
		#Apply horizontal movement
		velocity.x = direction * speed
	
	#Apply Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jumpCount = 0
		
	#Double Jump
	if Input.is_action_just_pressed("ui_accept") and jumpCount < maxJump:
		velocity.y = jumpVelocity
		jumpCount += 1
		
	#Cooldown Countdown
	if dashCooldownTimer > 0:
		dashCooldownTimer -= delta
	
	#Move the character
	move_and_slide()
