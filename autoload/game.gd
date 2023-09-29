extends Node

var score := 0

# Time left before the level fails due to time running out.
var time_left := 240.0

func _process(delta: float) -> void:
	time_left -= delta
