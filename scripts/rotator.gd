extends Node3D

# Export variables for rotation speeds (degrees per second)
@export var rotation_speed_x: float = 0.0  # Rotation speed around the X-axis
@export var rotation_speed_y: float = 0.0  # Rotation speed around the Y-axis
@export var rotation_speed_z: float = 0.0  # Rotation speed around the Z-axis

func _process(delta: float) -> void:
	# Calculate rotation increments based on delta time and rotation speeds
	var rotation_increment = Vector3(
		rotation_speed_x * delta,
		rotation_speed_y * delta,
		rotation_speed_z * delta
	)

	# Apply the rotation increment to the node's rotation
	rotation_degrees += rotation_increment
