class_name Brick
extends StaticBody3D

@export var explosion: GPUParticles3D
@export var animation_player: AnimationPlayer

func destroy() -> void:
	animation_player.play(&"destroy")
	#explosion.emitting = true
	# Some child nodes such as particles have their process mode set to Pausable,
	# so that they keep processing if their parent is disabled.
	process_mode = Node.PROCESS_MODE_DISABLED


func _on_explosion_finished() -> void:
	queue_free()
