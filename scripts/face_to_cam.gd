extends Node3D

func _process(_delta: float) -> void:
	look_at(get_tree().root.get_camera_3d().global_position)
