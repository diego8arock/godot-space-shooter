extends PanelContainer
class_name SkillContainer

export var skill_name : String = ""

func _ready():
	if not skill_name.empty():
		$SkillContainer/SkillName.text = skill_name
	
func set_skill_value(_value : String) -> void:
	$SkillContainer/SkillValue.text = _value
	
func set_modifed_value() -> void:
	$SkillContainer/SkillValue.add_color_override("font_color", Color(0,1,0,1))
	
func set_normal_value() -> void:
	$SkillContainer/SkillValue.add_color_override("font_color", Color(1,1,1,1))