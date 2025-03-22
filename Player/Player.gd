extends KinematicBody


export(float, 1, 20) var speeddir = 5
export(float, 0.1, 5) var speedr = 2
export(float, 1, 20) var jump_force = 10
export(float, 1, 50) var gravity = 20

var velocity := Vector3.ZERO


func _physics_process(delta):
	gravity(delta)
	move(delta)
	velocity = move_and_slide(velocity, Vector3.UP)





func gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0


func move(delta):
	var input_h = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	var input_v = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")

	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = jump_force
	
	var direction = -transform.basis.z * input_v * speeddir
	velocity.x = direction.x
	velocity.z = direction.z
	
	rotate_y(input_h * speedr * delta)