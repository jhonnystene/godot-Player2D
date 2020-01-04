extends KinematicBody2D

var gravity = 9.81
var velocity = Vector2(0, 0)
var speed = 150
var jumpVelocity = -200


func doAction(): # What to do when the action button is pressed
	pass


# Godot's default is_on_floor is pretty trash, so we use 2 RayCast2D nodes for floor detection.
# You can easily add more floor colliders, the code will auto-detect them.
func on_floor():
	for child in get_node("FloorDetection").get_children():
		if(child.is_colliding()):
			return true
	return false

func _physics_process(delta):
	var left = -int(Input.is_action_pressed("movement_left"))
	var right = int(Input.is_action_pressed("movement_right"))
	var jump = int(Input.is_action_pressed("movement_jump"))
	var action = int(Input.is_action_just_pressed("action"))
	
	if(action):
		doAction()
	
	velocity.x = (left + right) * speed # Pretty simple
	
	# Do animations, jumping, and gravity
	if(on_floor()):
		# Walking animations
		if(velocity.x != 0):
			get_node("player").animation = "move"
			if(velocity.x < 0):
				get_node("player").flip_h = true
			elif(velocity.x > 0):
				get_node("player").flip_h = false
		else:
			get_node("player").animation = "idle"
		
		# Jump is either 1 (player is holding jump) or 0 (player is not holding jump)
		# We want velocity.y to be set to 0 if the player isn't jumping. (jumpVelocity * 0)
		velocity.y = jumpVelocity * jump 
	else: # We aren't on the ground
		get_node("player").animation = "in_air" # Play the midair animation
		velocity.y += gravity # Apply gravity
	
	move_and_slide(velocity, Vector2(0, -1)) # Move based on current velocity