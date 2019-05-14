extends Node2D

func _on_Screens_start_game() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameManager.start_game()
