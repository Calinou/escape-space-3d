extends RigidBody3D

@export var paddle: MeshInstance3D

## The mouse sensitivity factor.
const MOUSE_SENSITIVITY = 0.1

## Speed multiplier for keyboard/gamepad movement.
const KEYBOARD_GAMEPAD_SPEED = 1.5

## The paddle's movement speed factor (this can be exceeded by fast mouse movements).
const MOVE_SPEED = 4.0

## The friction multiplier applied every physics frame.
## TODO: Make friction tickrate-independent.
const FRICTION = 0.75

# Stores mouse and keyboard/gamepad movement velocity on the X and Z axes.
var movement := Vector2()



func _ready() -> void:
	# Cap FPS to refresh rate as V-Sync is disabled to reduce input lag.
	Engine.max_fps = DisplayServer.screen_get_refresh_rate() + 1

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	# Convert mouse movement to actions, so you can control the paddle using the mouse.
	if event is InputEventMouseMotion:
		# Make mouse movement independent of the window scale factor, since we're using the `canvas_items`
		# stretch mode.
		var scale_factor: float = min(
			(float(get_viewport().size.x) / get_viewport().get_visible_rect().size.x),
			(float(get_viewport().size.y) / get_viewport().get_visible_rect().size.y)
		)
		movement += event.relative * MOUSE_SENSITIVITY * scale_factor
	#if event is InputEventMouseMotion:
		#var action_x := InputEventAction.new()
		#action_x.action = &"move_right" if event.relative.x >= 0 else &"move_left"
		#action_x.strength = remap(abs(event.relative.x), 0.0, MOUSE_SENSITIVITY, 0.2, 1.0)
		#action_x.pressed = true
		#Input.parse_input_event(action_x)
#
		#var action_y := InputEventAction.new()
		#action_y.action = &"move_down" if event.relative.y >= 0 else &"move_up"
		#action_y.strength = remap(abs(event.relative.y), 0.0, MOUSE_SENSITIVITY, 0.2, 1.0)
		#action_y.pressed = true
		#Input.parse_input_event(action_y)


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	movement += Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down") * KEYBOARD_GAMEPAD_SPEED
	state.linear_velocity = Vector3(movement.x, 0.0, movement.y) * MOVE_SPEED

	movement *= FRICTION

func _physics_process(delta: float) -> void:
	const MAX_LEAN_SPEED = 65.0
	const MAX_LEAN_ANGLE = deg_to_rad(15)
	paddle.rotation.z = clampf(remap(linear_velocity.x, -MAX_LEAN_SPEED, MAX_LEAN_SPEED, MAX_LEAN_ANGLE, -MAX_LEAN_ANGLE), -MAX_LEAN_ANGLE, MAX_LEAN_ANGLE)
	paddle.rotation.x = -clampf(remap(linear_velocity.z, -MAX_LEAN_SPEED, MAX_LEAN_SPEED, MAX_LEAN_ANGLE, -MAX_LEAN_ANGLE), -MAX_LEAN_ANGLE, MAX_LEAN_ANGLE)
