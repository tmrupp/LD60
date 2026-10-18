extends Node

@onready var body: RigidBody3D = $".."
@onready var parent = $"../.."

@onready var main = $"/root/Main"

var BULLET_FORCE = 4

func _ready ():
	#print($"../..", " body=", body)
	if parent is PhysicsBody3D:
		# Attached to something (hat/gun on an enemy): don't collide with the holder
		# or the other attached items, and stay put until shot off.
		body.add_collision_exception_with(parent)
		for child in parent.get_children():
			if child is CollisionObject3D and child != body:
				body.add_collision_exception_with(child)
		body.freeze = true

func bounce (bullet):
	print("bounce from transform:", bullet)
	#body.apply_force()
	body.reparent(main)
	body.freeze = false
	body.apply_impulse(bullet.basis.z*BULLET_FORCE, bullet.global_position)
