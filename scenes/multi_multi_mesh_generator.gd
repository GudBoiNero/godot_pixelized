@tool
extends Node3D  # Change from MultiMeshInstance3D to Node3D
class_name MultiMultiMeshGenerator

@export var target_mesh: MeshInstance3D = null : set = _set_target_mesh
@export var density: float = 10.0 : set = _set_density
@export var mesh_variants: Array[Mesh] = []  # List of different meshes to use
@export var update_multimesh: bool = false : set = _set_update_multimesh

var multimeshes: Array[MultiMeshInstance3D] = []

func _set_target_mesh(value):
	target_mesh = value
	if Engine.is_editor_hint():
		_update_multimesh()

func _set_density(value):
	density = value
	if Engine.is_editor_hint():
		_update_multimesh()

func _set_update_multimesh(value):
	update_multimesh = false
	if Engine.is_editor_hint():
		_update_multimesh()

func _ready():
	_update_multimesh()

func _update_multimesh():
	# Clear existing MultiMeshes
	for child in multimeshes:
		remove_child(child)
		child.queue_free()
	multimeshes.clear()

	if not target_mesh or mesh_variants.is_empty():
		return

	var surface_area = calculate_surface_area(target_mesh.mesh)
	if surface_area <= 0:
		return

	var instance_count = int(surface_area * density)
	print("Mesh surface area:", surface_area, "m², Instances:", instance_count)

	# Create one MultiMeshInstance3D per mesh variant
	for mesh in mesh_variants:
		var multi_mesh_instance = MultiMeshInstance3D.new()
		multi_mesh_instance.multimesh = MultiMesh.new()
		multi_mesh_instance.multimesh.transform_format = MultiMesh.TRANSFORM_3D
		multi_mesh_instance.multimesh.mesh = mesh
		multi_mesh_instance.multimesh.instance_count = instance_count / mesh_variants.size()
		add_child(multi_mesh_instance)
		multimeshes.append(multi_mesh_instance)

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
		area += 0.5 * ((b - a).cross(c - a)).length()

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
		var triangle_index = rng.randi_range(0, num_triangles - 1) * 3
		var a = vertices[triangle_index]
		var b = vertices[triangle_index + 1]
		var c = vertices[triangle_index + 2]

		var u = rng.randf()
		var v = rng.randf()
		if u + v > 1.0:
			u = 1.0 - u
			v = 1.0 - v
		
		var w = 1.0 - u - v
		var pos = (a * u) + (b * v) + (c * w)

		# Assign the instance to a random MultiMesh
		var mesh_index = rng.randi_range(0, mesh_variants.size() - 1)
		var multimesh = multimeshes[mesh_index].multimesh

		var transform = Transform3D()
		transform.origin = pos
		multimesh.set_instance_transform(i % multimesh.instance_count, transform)
