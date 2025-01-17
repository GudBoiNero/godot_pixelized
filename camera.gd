extends Node3D

@export var MOVE_SPEED: float = 20


func _physics_process(delta: float) -> void:
	var move_input: Vector3 = Vector3(
		Input.get_axis("left", "right"), 
		0, 
		Input.get_axis("up", "down")
	)

	var rotate_input: Vector2 = Vector2(Input.get_axis("ui_down", "ui_up"), Input.get_axis("ui_right", "ui_left"))

	rotation.y += rotate_input.y * delta
	rotation.x += rotate_input.x * delta
	position += move_input.rotated(Vector3.UP, rotation.y) * delta * MOVE_SPEED
