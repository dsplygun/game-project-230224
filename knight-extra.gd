extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if $AttackTimer.is_stopped():
			$AnimationTree["parameters/Idle/blend_position"] = direction
			$AnimationTree["parameters/Run/blend_position"] = direction
			$AnimationTree["parameters/Attack/blend_position"] = direction
		#else:
			#velocity.x = move_toward(velocity.x, 0, SPEED)
			
		$AnimationTree["parameters/playback"].travel("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimationTree["parameters/playback"].travel("Idle")
	if Input.is_action_just_pressed("attack") and is_on_floor():
		$AnimationTree["parameters/playback"].travel("Attack")
		if $AttackTimer.is_stopped():
			$AttackTimer.start()
		
	move_and_slide()
