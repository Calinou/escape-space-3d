extends Area3D

@export var destination: Vector3

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		# Teleport the player to the destination.
		body.position = destination
