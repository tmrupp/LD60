@tool
extends MeshInstance3D
## Triangle bandana wrapped onto a sphere. Put this node at the center of the head.

@export var radius := 0.26:
	set(v):
		radius = v
		_rebuild()
## How far the top edge wraps around each side of the head.
@export_range(10, 180) var wrap_degrees := 100.0:
	set(v):
		wrap_degrees = v
		_rebuild()
## Height of the top edge (0 = middle of the head, negative = lower).
@export_range(-90, 90) var top_degrees := 0.0:
	set(v):
		top_degrees = v
		_rebuild()
## Height of the bottom point.
@export_range(-90, 90) var tip_degrees := -65.0:
	set(v):
		tip_degrees = v
		_rebuild()
@export_range(1, 32) var rows := 12:
	set(v):
		rows = v
		_rebuild()
@export var color := Color(0.75, 0.1, 0.1):
	set(v):
		color = v
		_rebuild()


func _ready() -> void:
	_rebuild()


# Row i goes from 0 (the tip) to rows (the top edge); row i has i + 1 vertices.
func _vert(i: int, j: int) -> Vector3:
	var t := float(i) / rows
	var s := 0.0 if i == 0 else float(j) / i * 2.0 - 1.0
	var az := deg_to_rad(wrap_degrees) * s * t
	var el := deg_to_rad(lerpf(tip_degrees, top_degrees, t))
	# Face points toward -Z, like the gun.
	return Vector3(sin(az) * cos(el), sin(el), -cos(az) * cos(el)) * radius


func _add_tri(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3) -> void:
	for p in [a, b, c]:
		st.set_normal(p.normalized())
		st.add_vertex(p)


func _rebuild() -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in rows:
		for j in i + 1:
			_add_tri(st, _vert(i, j), _vert(i + 1, j + 1), _vert(i + 1, j))
			if j < i:
				_add_tri(st, _vert(i, j), _vert(i, j + 1), _vert(i + 1, j + 1))

	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	st.set_material(mat)
	mesh = st.commit()
