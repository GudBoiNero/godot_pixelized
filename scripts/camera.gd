extends Node3D

@export var MOVE_SPEED: float = 20
@export var ZOOM_SPEED: float = 5
@export var FAR_SPEED: float = 50

@export var camera: Camera3D

func _physics_process(delta: float) -> void:
	var move_input: Vector3 = Vector3(
		Input.get_axis("left", "right"), 
		0, 
		Input.get_axis("up", "down")
	)
	var zoom_input: float = Input.get_axis("ui_page_up", "ui_page_down")
	var far_input: float = Input.get_axis("ui_home", "ui_end")
	var rotate_input: Vector2 = Vector2(Input.get_axis("ui_down", "ui_up"), Input.get_axis("ui_right", "ui_left"))

	camera.size += zoom_input * ZOOM_SPEED * delta
	camera.position.z += far_input * FAR_SPEED * delta
	rotation.y += rotate_input.y * delta
	rotation.x += rotate_input.x * delta
	position += move_input.rotated(Vector3.UP, rotation.y) * delta * MOVE_SPEED
