extends Node3D

@onready var area_3d: Area3D = $Area3D
@onready var camera: Camera3D = $Camera3D

const SPEED = 20
const MOUSE_SENSITIVITY = 0.002

var flying : bool
var ignore_collision : Node3D

func _ready() -> void:
	area_3d.body_entered.connect(_on_body_entered)
	flying = true
	ignore_collision = null

func _physics_process(delta: float) -> void:
	if flying:
		position += SPEED * delta * (global_basis * Vector3.FORWARD)

func _unhandled_input(event: InputEvent) -> void:
	if not flying:
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate(basis.y, -event.relative.x * MOUSE_SENSITIVITY)
			rotate(basis.x, -event.relative.y * MOUSE_SENSITIVITY)
			basis = basis.orthonormalized()
		
		if event.is_action_pressed("shoot"):
			flying = true
	
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_body_entered(other : Node3D):
	if ignore_collision != null and other == ignore_collision:
		return
	print("body entered: ", other.name)
	flying = false
	
	ignore_collision = other
	
	if "receive_impact" in other:
		other.receive_impact(Vector3.ZERO)
