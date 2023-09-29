class_name Player
extends RigidBody3D

## The mouse sensitivity factor.
const MOUSE_SENSITIVITY = 0.1

## Speed multiplier for keyboard/gamepad movement.
const KEYBOARD_GAMEPAD_SPEED = 1.5

## The paddle's movement speed factor (this can be exceeded by fast mouse movements).
const MOVE_SPEED = 3.0

## The friction multiplier applied every physics frame.
## TODO: Make friction tickrate-independent.
const FRICTION = 0.8

## The friction multiplier applied every physics frame on the camera movement.
const CAMERA_FRICTION = 0.95

# Stores mouse and keyboard/gamepad movement velocity on the X and Z axes.
var movement := Vector2()

@onready var camera_base_rotation: Vector3 = %Camera3D.rotation

var camera_added_rotation := Vector3()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Cap FPS to refresh rate as V-Sync is disabled to reduce input lag.
	Engine.max_fps = int(DisplayServer.screen_get_refresh_rate()) + 1


func _input(event: InputEvent) -> void:
	# Paddle movement using the mouse.
	if event is InputEventMouseMotion:
		# Make mouse movement independent of the window scale factor, since we're using the `canvas_items`
		# stretch mode.
		var scale_factor: float = min(
			(float(get_viewport().size.x) / get_viewport().get_visible_rect().size.x),
			(float(get_viewport().size.y) / get_viewport().get_visible_rect().size.y)
		)
		movement += event.relative * scale_factor * MOUSE_SENSITIVITY


func _process(_delta: float) -> void:
	if Game.score > int(%ScoreLabel.text):
		# Tint score if it has recently increased.
		%ScoreLabel.outline_modulate = Color.YELLOW

	%ScoreLabel.text = str(Game.score)
	# Fade score outline towards black continuously.
	%ScoreLabel.outline_modulate = %ScoreLabel.outline_modulate.lerp(Color.BLACK, 0.05)


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	# Paddle movement using the keyboard or gamepad.
	movement += Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down") * KEYBOARD_GAMEPAD_SPEED

	# Apply movement and friction.
	state.linear_velocity = Vector3(movement.x, 0.0, movement.y) * MOVE_SPEED
	movement *= FRICTION


func _physics_process(_delta: float) -> void:
	# Lean paddle depending on movement speed.
	const MAX_LEAN_SPEED = 65.0
	const MAX_LEAN_ANGLE = deg_to_rad(15)
	%Paddle.rotation.z = clampf(remap(linear_velocity.x, -MAX_LEAN_SPEED, MAX_LEAN_SPEED, MAX_LEAN_ANGLE, -MAX_LEAN_ANGLE), -MAX_LEAN_ANGLE, MAX_LEAN_ANGLE)
	%Paddle.rotation.x = -clampf(remap(linear_velocity.z, -MAX_LEAN_SPEED, MAX_LEAN_SPEED, MAX_LEAN_ANGLE, -MAX_LEAN_ANGLE), -MAX_LEAN_ANGLE, MAX_LEAN_ANGLE)

	# Tilt camera depending on movement speed.
	camera_added_rotation.x += clampf(remap(linear_velocity.z, -MAX_LEAN_SPEED * 25, MAX_LEAN_SPEED * 25, MAX_LEAN_ANGLE, -MAX_LEAN_ANGLE), -MAX_LEAN_ANGLE, MAX_LEAN_ANGLE)
	camera_added_rotation.y += clampf(remap(linear_velocity.x, -MAX_LEAN_SPEED * 25, MAX_LEAN_SPEED * 25, MAX_LEAN_ANGLE, -MAX_LEAN_ANGLE), -MAX_LEAN_ANGLE, MAX_LEAN_ANGLE)

	%Camera3D.rotation.x = camera_base_rotation.x + camera_added_rotation.x
	%Camera3D.rotation.y = camera_base_rotation.y + camera_added_rotation.y

	camera_added_rotation *= CAMERA_FRICTION
