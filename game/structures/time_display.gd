extends Node3D

@export var text_foreground: MeshInstance3D
@export var time_color: Gradient

func _process(_delta: float) -> void:
	text_foreground.get_surface_override_material(0).emission = time_color.sample(remap(Game.time_left, 240, 0, 0.0, 1.0))
	text_foreground.mesh.text = "%d %02d" % [ceili(Game.time_left) / 60, ceili(Game.time_left) % 60]

	if Game.time_left <= 20.0:
		# Make text blink when time remaining is low.
		text_foreground.transparency = 0.96 if (ceili(Game.time_left * 2)) % 2 == 0 else 0.0
