extends Control

var level
var xp
var req_xp
var static_xp = [0,0,673,690,707,724,741,758,775,793,811,829,847,1039] #taken from Dark Souls

onready var container = $VBoxContainer
onready var xp_value = $VBoxContainer/XP/Value
onready var level_value = $VBoxContainer/Level/Value
onready var req_xp_value = $VBoxContainer/RequieredXP/Value
onready var bttn_continue = $VBoxContainer/Buttons/Continue

func _ready() -> void:
	GameManager.stats_gui = self

func set_level(_level : int) -> void:
	level = _level
	level_value.text = str(_level)

func set_xp(_xp : int) -> void:
	xp = _xp
	xp_value.text = str(_xp)

func calculate_req_xp_value() -> void:
	var next_lvl = level + 1
	if next_lvl < 13:
		req_xp = static_xp[next_lvl]
	else:
		req_xp = abs(int(0.02 * pow(next_lvl, 3) + 3.06 * pow(next_lvl, 2) + 105.6 * next_lvl - 895)) #taken from Dark Souls
	req_xp_value.text = str(req_xp)
	
func on_StatContianer_add_stat() -> void:
	set_level(level + 1)
	calculate_req_xp_value()
	xp -= req_xp
	xp_value.text = "0" if xp < 0 else str(xp)
	validate_req_xp() 

func on_StatContianer_sub_stat() -> void:
	set_level(level - 1)
	xp += req_xp
	xp_value.text =  "0" if xp < 0 else str(xp)
	calculate_req_xp_value()
	validate_req_xp() 
	
func validate_req_xp() -> void:
	if req_xp > xp:
		req_xp_value.add_color_override("font_color", Color(1,0,0,1))
		bttn_continue.disabled = true
	else:
		req_xp_value.add_color_override("font_color", Color(1,1,1,1))
		bttn_continue.disabled = false

func set_stats_values() -> void:
	for stat in GameManager.stats_temp:
		var node = container.get_node(stat) as StatContainer
		node.set_value(GameManager.stats[stat])		
	
	
	
	
