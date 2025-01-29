extends Node3D

func _input(event: InputEvent):
	if event is InputEventKey and event.pressed and event.keycode == KEY_F11:
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_FULLSCREEN 
			if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN
			else DisplayServer.WINDOW_MODE_WINDOWED
		)
