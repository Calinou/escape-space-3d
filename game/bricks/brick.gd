class_name Brick
extends StaticBody3D

func destroy() -> void:
	%AnimationPlayer.play(&"destroy")
	# Some child nodes such as particles have their process mode set to Pausable,
	# so that they keep processing if their parent is disabled.
	process_mode = Node.PROCESS_MODE_DISABLED


func _on_explosion_finished() -> void:
	queue_free()
