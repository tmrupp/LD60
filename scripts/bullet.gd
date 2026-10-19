extends Node3D

@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var camera: Camera3D = $Camera3D

const SPEED = 20
const MOUSE_SENSITIVITY = 0.002

var flying : bool
var ready_to_shoot : bool
var ignore_collision : Node3D
var on_bullet_hit_callback : Variant = null
var on_bullet_ricochet_callback : Variant = null

var camera_pos_during_flight : Vector3
var camera_pos_during_aiming : Vector3 = Vector3.ZERO

func _ready() -> void:
	flying = true
	ignore_collision = null
	camera_pos_during_flight = camera.position

func _physics_process(delta: float) -> void:
	if flying:
		position += SPEED * delta * (global_basis * Vector3.FORWARD)
		if ray_cast_3d.is_colliding():
			on_raycast_collision()

func _unhandled_input(event: InputEvent) -> void:
	if not flying:
		if ready_to_shoot:
			if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				rotate(basis.y, -event.relative.x * MOUSE_SENSITIVITY)
				rotate(basis.x, -event.relative.y * MOUSE_SENSITIVITY)
				basis = basis.orthonormalized()
			
			if event.is_action_pressed("shoot"):
				if body and body.has_node("Bouncable"):
					var bouncable = body.get_node("Bouncable")
					bouncable.bounce(self)
					#print("shot a bouncable")
				flying = true
				ready_to_shoot = false
				if on_bullet_hit_callback != null:
					on_bullet_ricochet_callback.call()
				
				var tween = get_tree().create_tween().bind_node(self)
				tween.tween_property(camera, "position", camera_pos_during_flight, 0.1)
	else: # if flying
		if event.is_action_pressed("recall"):
			pass
	
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

var body 
func on_raycast_collision():
	var other = ray_cast_3d.get_collider()
	if other == null:
		return
	
	if ignore_collision != null and other == ignore_collision:
		return
	
	if on_bullet_hit_callback != null:
		on_bullet_hit_callback.call()
	
	print("body entered: ", other.name)
	body = other
	
	flying = false
	
	ignore_collision = other
	
	if "receive_impact" in other:
		other.receive_impact()
	
	# begin moving the camera to the position offset used for aiming
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(camera, "position", camera_pos_during_aiming, 0.1)
	
	# begin rotating the bullet to face in the direction of a natural bounce
	var norm = ray_cast_3d.get_collision_normal()
	var incident = -global_basis.z
	tween.set_parallel()
	tween.tween_property(self, "global_basis", Basis.looking_at(incident.bounce(norm)), 0.1)
	tween.tween_method(func(_v): global_basis = global_basis.orthonormalized(), 0, 0, 0.1)
	tween.set_parallel(false)
	tween.tween_callback(func():
		ready_to_shoot = true
	)
