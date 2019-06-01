extends CanvasLayer

class_name BaseScreen, "res://screens/BaseScreen.gd"

onready var tween = $Tween
onready var label = $MarginContainer/VBoxContainer/Label

func disappear() -> void:
	tween.interpolate_property(self, "offset:x", 0, 1100, 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
	
func appear() -> void:
	tween.interpolate_property(self, "offset:x", 1100, 0, 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

func set_text_blank() -> void:
	label.text = ""

func update_text_as_timer(_value : int) -> void:
	if _value > 0:
		label.text = str(_value)
	else:
		label.text = "GO!"
		
func set_text(_message : String) -> void:
	label.text = _message
	
func set_subtitle(_message : String) -> void:
	$MarginContainer/VBoxContainer/SubTitle.text = _message