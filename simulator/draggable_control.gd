extends Control
class_name DraggablePanel, "res://simulator/draggable_control.gd"

var move_panel: bool = false

func _ready():
	pass

func _process(delta: float) -> void:
	
	if move_panel and Input.is_mouse_button_pressed(BUTTON_LEFT):
		rect_global_position = get_viewport().get_mouse_position()
		
func _on_PanelContainer_mouse_entered() -> void:
	move_panel = true

func _on_PanelContainer_mouse_exited() -> void:
	move_panel = false