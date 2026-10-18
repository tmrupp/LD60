extends Node3D

@onready var bullet_scene = preload("res://scenes/bad_bullet.tscn")

func shoot ():
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = global_position
	bullet.global_rotation = global_rotation
