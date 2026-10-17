extends Node3D

@onready var bullet_prefab = preload("res://scenes/bullet.tscn")
@onready var shooter = $"../Camera3D"

var allow_player_shoot : bool = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and allow_player_shoot:
		shoot()

func shoot():
	var new_bullet = bullet_prefab.instantiate()
	get_tree().root.add_child(new_bullet)
	new_bullet.global_position = shooter.global_position
	new_bullet.global_rotation = shooter.global_rotation
	new_bullet.ignore_collision = $".."
	var bullet_cam : Camera3D = new_bullet.get_node("Camera3D")
	bullet_cam.make_current()
	allow_player_shoot = false
