extends RigidBody3D

const ROTATE_SPEED = 9.0
const AUDIO_MAX_SPEED = 25.0

## Absolute maximum speed in units per second.
const MAX_SPEED = 45.0

func _process(_delta: float) -> void:
	%Comet.rotation = linear_velocity * ROTATE_SPEED

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	state.linear_velocity = linear_velocity.clamp(Vector3.ONE * -MAX_SPEED, Vector3.ONE * MAX_SPEED)


func _on_body_entered(body: Node) -> void:
	# Play bouncing sound.
	%AudioStreamPlayer3D.volume_db = minf(remap(linear_velocity.length(), 0, AUDIO_MAX_SPEED, -16, 0), 0)
	%AudioStreamPlayer3D.pitch_scale = minf(remap(linear_velocity.length(), 0, AUDIO_MAX_SPEED, 0.6, 1.1), 1.1)
	%AudioStreamPlayer3D.play()

	if body is Brick:
		# Break the brick.
		body.destroy()
		Game.score += 100
