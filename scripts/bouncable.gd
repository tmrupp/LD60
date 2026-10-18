extends Node

@onready var body: RigidBody3D = $".."

@onready var main = $"/root/Main"

func bounce (bullet):
	print("bounce from transform:", bullet)
	#body.apply_force()
	body.reparent(main)
	body.apply_impulse(bullet.basis.z, bullet.global_position)
