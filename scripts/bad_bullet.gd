extends Node3D
@onready var ray_cast_3d: RayCast3D = $RayCast3D

const SPEED = 1

func _physics_process(delta: float) -> void:
	position += SPEED * delta * (global_basis * Vector3.FORWARD)
	if ray_cast_3d.is_colliding():
		on_raycast_collision()

func on_raycast_collision():
	var other = ray_cast_3d.get_collider()
	
	if "receive_impact" in other:
		other.receive_impact()
		
	queue_free.call_deferred()
