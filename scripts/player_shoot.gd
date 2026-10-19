extends Node3D

@onready var bullet_prefab = preload("res://scenes/bullet.tscn")
@onready var shooter = $"../Camera3D"
@onready var timer_ui = $"/root/Main/CanvasLayer/Control/MarginContainer/TextureRect"
@onready var sub_camera_ui = $"/root/Main/CanvasLayer/SubCamera"

var allow_player_shoot : bool = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and allow_player_shoot:
		shoot()

func shoot():
	var parent = $".."
	
	var new_bullet = bullet_prefab.instantiate()
	get_tree().root.add_child(new_bullet)
	new_bullet.global_position = shooter.global_position
	new_bullet.global_rotation = shooter.global_rotation
	new_bullet.ignore_collision = parent
	new_bullet.on_bullet_hit_callback = func():
		timer_ui.start_timer(2.0, func():
			allow_player_shoot = true
			shooter.make_current()
			new_bullet.queue_free()
			sub_camera_ui.hide()
			parent.allow_player_control = true
		)
	new_bullet.on_bullet_ricochet_callback = func():
		timer_ui.clear_timer()
	
	var bullet_cam : Camera3D = new_bullet.get_node("Camera3D")
	bullet_cam.make_current()
	
	allow_player_shoot = false
	parent.allow_player_control = false
	
	sub_camera_ui.show()
