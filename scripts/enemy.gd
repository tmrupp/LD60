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

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(_delta):
	look_at(player.position, Vector3.UP)
	if not shooting:
		set_movement_target(player.position)
		# Do not query when the map has never synchronized and is empty.
		if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
			return
		if navigation_agent.is_navigation_finished():
			return

		var next_path_position: Vector3 = navigation_agent.get_next_path_position()
		var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
		if navigation_agent.avoidance_enabled:
			navigation_agent.set_velocity(new_velocity)
		else:
			_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()
