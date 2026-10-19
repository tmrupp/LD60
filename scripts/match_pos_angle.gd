extends Camera3D

@export var follow_me_path : NodePath
var follow_me : Node3D

func _ready() -> void:
	follow_me = get_node(follow_me_path)

func _process(_delta: float) -> void:
	global_position = follow_me.global_position
	global_basis = follow_me.global_basis
