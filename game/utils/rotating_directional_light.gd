extends DirectionalLight3D


func _process(_delta: float) -> void:
	# Jitter DirectionalLight3D rotation to improve quality with TAA by reducing visible noise.
	rotate_object_local(Vector3.FORWARD, randf())
