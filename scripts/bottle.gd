extends RigidBody3D

@onready var break_sfx: AudioStreamPlayer = $BreakSFX
var SPIN_SPEED = 7
var thrown = false

func receive_impact():
	break_sfx.play()

func yield_ricochets() -> int:
	return 1
	
func _ready() -> void:
	# 1. Enable monitoring
	contact_monitor = true
	max_contacts_reported = 5
	
	# 2. Connect the signal to your function programmatically
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if thrown:
		queue_free()

func calculate_throw_velocity(start_pos: Vector3, target_pos: Vector3, gravity: Vector3, time: float) -> Vector3:
	# Displacement
	var displacement = target_pos - start_pos
	# Solve for velocity: v = (displacement - 0.5 * gravity * t^2) / t
	var velocity = (displacement - (0.5 * gravity * time * time)) / time
	return velocity

func add_exceptions_recursive (node: Node):
	# Ignore the thrower and anything attached to it (hat, bandana, ...), otherwise
	# the bottle hits the frozen hat/bandana on the way out and just drops.
	if node is PhysicsBody3D:
		add_collision_exception_with(node)
	for child in node.get_children():
		add_exceptions_recursive(child)

func throw (thrower, target: Vector3):
	add_exceptions_recursive(thrower)
	thrown = true
	linear_velocity = calculate_throw_velocity(global_position, target, Vector3(0, -ProjectSettings.get_setting("physics/3d/default_gravity"), 0), 1.0)
	angular_velocity = basis.x*SPIN_SPEED
	#apply_central_impulse(vel * mass)
	
	
