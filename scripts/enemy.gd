extends CharacterBody3D

@export var movement_speed: float = 2.0
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

@onready var bottle_scene = "res://scenes/bottle.tscn"
@onready var gun = $Gun

@onready var player = $"../Player"

var shooting = false

func _range_entered (body):
	if body == player:
		shooting = true
		navigation_agent.set_velocity(Vector3.ZERO)
		print("can hit player")
		
func _range_exited (body):
	if body == player:
		shooting = false
		print("cannot hit player")

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	$GunRange.connect("body_entered", _range_entered)
	$GunRange.connect("body_exited", _range_exited)
	
	if $GunRange.has_overlapping_bodies() and player in $GunRange.get_overlapping_bodies():
		_range_entered(player)
		
	
func _gun_hit ():
	pass

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	# Apply gravity so the enemy stays grounded.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Face the player, but only rotate horizontally.
	var face_target: Vector3 = player.global_position
	face_target.y = global_position.y
	if global_position.distance_to(face_target) > 0.01:
		look_at(face_target, Vector3.UP)

	var horizontal_velocity: Vector3 = Vector3.ZERO
	if not shooting:
		set_movement_target(player.global_position)
		# Do not query when the map has never synchronized and is empty.
		var map_ready: bool = NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) != 0
		if map_ready and not navigation_agent.is_navigation_finished():
			var next_path_position: Vector3 = navigation_agent.get_next_path_position()
			horizontal_velocity = global_position.direction_to(next_path_position) * movement_speed

	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	move_and_slide()

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()
