extends CharacterBody3D

@export var movement_speed: float = 2.0
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

@onready var bottle_scene = preload("res://scenes/bottle.tscn")
@onready var gun = $Gun

@onready var player = $"../Player"
@onready var timer = $Timer

var FIRE_RATE = 4.0

#@onready var hat = $Hat
#@onready var bandana = $Bandana

var shooting = false

func die ():
	queue_free()
	$"/root/Main".outlaw_count -= 1

func receive_impact():
	#print("struck")
	if has_node("Bandana"):
		$Bandana/Bouncable.bounce(Vector3.UP)
	elif has_node("Hat"):
		$Hat/Bouncable.bounce(Vector3.UP)
	else:
		die()

func _range_entered (body):
	if body == player:
		shooting = true
		navigation_agent.set_velocity(Vector3.ZERO)
		timer.start()
		print("can hit player")
		
func _range_exited (body):
	if body == player:
		shooting = false
		print("cannot hit player")

func shoot ():
	if has_node("Gun"):
		$Gun/Shootable.shoot()
	else:
		#throw()
		shooting = false
		timer.timeout.disconnect(shoot)
		timer.timeout.connect(throw)
		$ThrowRange.connect("body_entered", _range_entered)
		$ThrowRange.connect("body_exited", _range_exited)
		
	
func throw ():
	var bottle = bottle_scene.instantiate()
	get_tree().root.add_child(bottle)
	bottle.global_position = global_position
	bottle.global_rotation = global_rotation
	bottle.throw.call_deferred(self, player.global_position)

func _ready() -> void:
	$"/root/Main".outlaw_count += 1
	
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	$GunRange.connect("body_entered", _range_entered)
	$GunRange.connect("body_exited", _range_exited)
	
	if $GunRange.has_overlapping_bodies() and player in $GunRange.get_overlapping_bodies():
		_range_entered(player)
		
	timer.wait_time = FIRE_RATE
	timer.timeout.connect(shoot)

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
