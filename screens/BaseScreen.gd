extends CanvasLayer

class_name BaseScreen, "res://screens/base_screen.gd"

onready var tween = $Tween

func disappear() -> void:
	tween.interpolate_property(self, "offset:x", 0, 1500, 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
	
func appear() -> void:
	tween.interpolate_property(self, "offset:x", 1500, 0, 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
	
func disable_buttons() -> void:
	var buttons = get_tree().get_nodes_in_group("menu_buttons")
	for b in buttons:
		b.disabled = true
