extends MultiMeshInstance3D

@export var target_mesh: MeshInstance3D  # Assign your target mesh
@export var density: float = 10.0  # Instances per square meter

func _ready():
	var surface_area = calculate_surface_area(target_mesh.mesh)
	if surface_area <= 0:
		return

	var instance_count = int(surface_area * density)
	print("Mesh surface area:", surface_area, "m², Instances:", instance_count)

	var multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.mesh = QuadMesh.new()  # Can be replaced with a billboard sprite mesh
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
	var num_vertices = vertices.size()
	
	for i in range(instance_count):
		var random_index = randi() % num_vertices
		var pos = vertices[random_index]  # Random vertex from the mesh
		var transform = Transform3D()
		transform.origin = pos
		multimesh.set_instance_transform(i, transform)
