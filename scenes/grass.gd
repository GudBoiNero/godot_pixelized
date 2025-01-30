@tool
extends MultiMeshInstance3D

@export var target_mesh: MeshInstance3D = null : set = _set_target_mesh
@export var density: float = 10.0 : set = _set_density
@export var update_multimesh: bool = false : set = _set_update_multimesh

func _set_target_mesh(value):
	target_mesh = value
	if Engine.is_editor_hint():
		_update_multimesh()

func _set_density(value):
	density = value
	if Engine.is_editor_hint():
		_update_multimesh()

func _set_update_multimesh(value):
	update_multimesh = false  # Reset button after clicking
	if Engine.is_editor_hint():
		_update_multimesh()

func _update_multimesh():
	if not target_mesh or not multimesh.mesh or not target_mesh.mesh:
		return

	var surface_area = calculate_surface_area(target_mesh.mesh)
	if surface_area <= 0:
		return

	var instance_count = int(surface_area * density)
	print("Mesh surface area:", surface_area, "m², Instances:", instance_count)

	var multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = instance_count
	self.multimesh = multimesh
	
	place_instances(instance_count)

func calculate_surface_area(mesh: Mesh) -> float:
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(mesh, 0)
	var array_mesh = surface_tool.commit()
	if not array_mesh:
		return 0.0

	var faces = array_mesh.get_faces()
	var area = 0.0

	for i in range(0, faces.size(), 3):
		var a = faces[i]
		var b = faces[i+1]
		var c = faces[i+2]
		area += 0.5 * ((b - a).cross(c - a)).length()  # Triangle area formula

	return area

func place_instances(instance_count: int):
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(target_mesh.mesh, 0)
	var array_mesh = surface_tool.commit()
	
	if not array_mesh:
		return

	var vertices = array_mesh.get_faces()
	var num_triangles = vertices.size() / 3
	
	var rng = RandomNumberGenerator.new()

	for i in range(instance_count):
		# Pick a random triangle
		var triangle_index = rng.randi_range(0, num_triangles - 1) * 3
		var a = vertices[triangle_index]
		var b = vertices[triangle_index + 1]
		var c = vertices[triangle_index + 2]

		# Generate random barycentric coordinates
		var u = rng.randf()
		var v = rng.randf() * (1.0 - u)
		var w = 1.0 - u - v

		# Compute the final position inside the triangle
		var pos = (a * u) + (b * v) + (c * w)

		# Assign to the MultiMesh instance
		var transform = Transform3D()
		transform.origin = pos
		multimesh.set_instance_transform(i, transform)
