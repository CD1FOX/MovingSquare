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

#Slowmotion Variables
var isSlowMotion = false
var slowMotionTimer = 0.0
var slowMotionCooldownTimer = 0.0

#Smooth Movement Variables
var testSpeed = 2

#Main Physics
func _physics_process(delta: float) -> void:
	var direction = 0
	var speed = normalSpeed
	
	if Input.is_action_pressed("Click"):
		var target_position = get_global_mouse_position()
		position = lerp(position, target_position, testSpeed * delta)
	
	#Slow Motion
	if Input.is_action_just_pressed("Slow Motion") and not isSlowMotion and slowMotionCooldownTimer <= 0:
		isSlowMotion = true
		if Engine.time_scale == 1.0:
			Engine.time_scale = 0.3
		slowMotionTimer = 1.0
		slowMotionCooldownTimer = 3.0
	
	if isSlowMotion:
		slowMotionTimer -= delta
		if slowMotionTimer <= 0:
			isSlowMotion = false
	else:
		Engine.time_scale = 1.0
		
	
	#Left / Right Input
	if Input.is_action_pressed("Left"):
		direction -= 1
	if Input.is_action_pressed("Right"):
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
	if Input.is_action_just_pressed("Jump") and jumpCount < maxJump:
		$ColorRect.color = Color(randf(), randf(), randf())
		velocity.y = jumpVelocity
		jumpCount += 1
		
	#Cooldown Countdown
	if dashCooldownTimer > 0:
		dashCooldownTimer -= delta
		
	if slowMotionCooldownTimer != 0:
		slowMotionCooldownTimer -= delta
	
	
	#Move the character
	move_and_slide()
