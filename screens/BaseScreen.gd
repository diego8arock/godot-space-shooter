extends CanvasLayer

class_name BaseScreen, "res://screens/BaseScreen.gd"

onready var tween = $Tween

func disappear() -> void:
	tween.interpolate_property(self, "offset:x", 0, 1100, 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
	
func appear() -> void:
	tween.interpolate_property(self, "offset:x", 1100, 0, 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
	
func disable_buttons() -> void:
	var buttons = get_tree().get_nodes_in_group("menu_buttons")
	for b in buttons:
		b.disabled = true

func set_text_blank() -> void:
	$MarginContainer/VBoxContainer/Label.text = ""

func update_text_as_timer(_value) -> void:
	if _value > 0:
		$MarginContainer/VBoxContainer/Label.text = str(_value)
	else:
		$MarginContainer/VBoxContainer/Label.text = "GO!"