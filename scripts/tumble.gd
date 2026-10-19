extends Node3D

func _process(delta: float) -> void:
	rotation.x += 0.1 * delta
	rotation.y += delta
	rotation.z += 0.3 * delta
