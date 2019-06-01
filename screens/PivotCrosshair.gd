extends CheckButton

func _on_PivotCrosshair_toggled(button_pressed: bool) -> void:
	GameManager.use_crosshair_as_pivot = button_pressed
