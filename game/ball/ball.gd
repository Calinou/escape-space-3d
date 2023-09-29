extends RigidBody3D

const ROTATE_SPEED = 9.0
const AUDIO_MAX_SPEED = 25.0

## Absolute maximum speed in units per second.
const MAX_SPEED = 45.0

@export var comet: MeshInstance3D
@export var audio_stream_player: AudioStreamPlayer3D

func _process(_delta: float) -> void:
	comet.rotation = linear_velocity * ROTATE_SPEED

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	state.linear_velocity = linear_velocity.clamp(Vector3.ONE * -MAX_SPEED, Vector3.ONE * MAX_SPEED)


func _on_body_entered(body: Node) -> void:
	# Play bouncing sound.
	audio_stream_player.volume_db = minf(remap(linear_velocity.length(), 0, AUDIO_MAX_SPEED, -16, 0), 0)
	audio_stream_player.pitch_scale = minf(remap(linear_velocity.length(), 0, AUDIO_MAX_SPEED, 0.6, 1.1), 1.1)
	audio_stream_player.play()

	if body is Brick:
		# Break the brick.
		body.destroy()
		Game.score += 100
