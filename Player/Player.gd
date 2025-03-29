extends KinematicBody

export(float, 1, 20) var speeddir = 5
export(float, 1, 20) var jump_force = 10
export(float, 1, 50) var gravity = 20
export(float, 0, 1) var mouse_sensitivity = 0.02
export(float, -1.2, 1.2) var camera_min_angle = -1.2  
export(float, -1.2, 1.2) var camera_max_angle = 1.2  

onready var camera_pivot = $CameraPivot
onready var camera = $CameraPivot/Camera  

var velocity := Vector3.ZERO
var camera_rotation_y := 0.0

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 


func _input(event):
    if event is InputEventMouseMotion:
        camera_rotation_y -= event.relative.x * mouse_sensitivity * 10
        camera_pivot.rotation_degrees.y = camera_rotation_y

        var new_x_rotation = camera_pivot.rotation_degrees.x - event.relative.y * mouse_sensitivity * 10
        camera_pivot.rotation_degrees.x = clamp(new_x_rotation, rad2deg(camera_min_angle), rad2deg(camera_max_angle))

func _physics_process(delta):
    apply_gravity(delta)
    move(delta)
    velocity = move_and_slide(velocity, Vector3.UP)



func apply_gravity(delta):
    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        velocity.y = 0


func move(delta):
    var input_h = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    var input_v = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")

    if Input.is_action_just_pressed("ui_select") and is_on_floor():
        velocity.y = jump_force

    var cam_basis = camera_pivot.global_transform.basis  

    var forward = -cam_basis.z.normalized()
    var right = cam_basis.x.normalized()

    var direction = (right * input_h + forward * input_v).normalized() * speeddir

    velocity.x = direction.x
    velocity.z = direction.z
