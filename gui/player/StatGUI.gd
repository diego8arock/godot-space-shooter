extends Control

var level
var xp
var req_xp
var static_xp = [0,0,673,690,707,724,741,758,775,793,811,829,847,1039] #taken from Dark Souls

onready var container_stats = $Panel/VBoxContainer/Container/StatsContainers
onready var container_skills = $Panel/VBoxContainer/Container/SkillsContainer
onready var xp_value = $Panel/VBoxContainer/XP/Value
onready var level_value = $Panel/VBoxContainer/Level/Value
onready var req_xp_value = $Panel/VBoxContainer/RequieredXP/Value
onready var bttn_continue = $Panel/VBoxContainer/Buttons/HBoxContainer/Continue

func _ready() -> void:
	GameManager.stats_gui = self
	for c in $Panel/VBoxContainer/Container/StatsContainers.get_children():
		if c is StatContainer:
			c.parent = self
			c.connect_button_signals()
			
func initialize() -> void:
	set_level(GameManager.player_level)
	set_xp(GameManager.player_xp)
	calculate_req_xp_value()
	validate_req_xp() 
	set_stats_values()
	set_skills_values()
	set_health_value()

func set_level(_level : int) -> void:
	level = _level
	level_value.text = str(level)

func set_xp(_xp : int ) -> void:
	xp = _xp
	xp_value.text = "0" if xp < 0 else str(xp)
	GameManager.temp_player_xp = xp

func calculate_req_xp_value() -> void:
	var next_lvl = level + 1
	if next_lvl < 13:
		req_xp = static_xp[next_lvl]
	else:
		req_xp = abs(int(0.02 * pow(next_lvl, 3) + 3.06 * pow(next_lvl, 2) + 105.6 * next_lvl - 895)) #taken from Dark Souls
	req_xp_value.text = str(req_xp)
	
func on_StatContianer_add_stat(_name) -> void:
	update_skills_values(_name)
	set_level(level + 1)
	calculate_req_xp_value()	
	xp -= req_xp
	set_xp(xp)
	validate_req_xp() 

func on_StatContianer_sub_stat(_name) -> void:
	update_skills_values(_name)
	set_level(level - 1)
	xp += req_xp
	set_xp(xp)
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
		var node = container_stats.get_node(stat) as StatContainer
		node.set_value(GameManager.stats_temp[stat])		
	
func set_skills_values() -> void:
	var rotation_speed = ConstManager.calculate_rotation_speed(GameManager.stats["Speed"]) 
	var damage_reduction = ConstManager.calculate_damage_reduction(GameManager.stats["Armor"]) 
	var bullet_damage = ConstManager.calculate_bullet_damage(GameManager.stats["Attack"])
	var charge_rate = ConstManager.calculate_charge_rate(GameManager.stats["Power"])
	var combo_rate = ConstManager.calculate_combo_rate(GameManager.stats["Combo"]) 
	var shooting_rate = ConstManager.calculate_shooting_rate(GameManager.stats["Attack"]) +  ConstManager.calculate_shooting_rate(GameManager.stats["Speed"])
	var cooldown_rate = ConstManager.calculate_cooldown_rate(GameManager.stats["Combo"]) + ConstManager.calculate_cooldown_rate(GameManager.stats["Power"]) 
	set_skill_value("RotationSpeed",rotation_speed)
	set_skill_value("BulletDamage",bullet_damage)
	set_skill_value("ShootingRate",shooting_rate)
	set_skill_value("DamageReduction",damage_reduction)
	set_skill_value("ChargeRate",charge_rate)
	set_skill_value("CooldownRate",cooldown_rate)
	set_skill_value("ComboRate",combo_rate)
	
func set_skill_value(_skill_name : String, _value : float) -> void:
	get_skill(_skill_name).set_skill_value(str(parse_to_round_int(_value)))
	get_skill(_skill_name).set_normal_value()
	
func get_skill(_name : String) -> SkillContainer:
	return container_skills.get_node(_name) 
	
func update_skills_values(_name : String) -> void:
	DebugManager.debug(name + "-update_skills_values", _name)
	match _name:
		"Power":
			var charge_rate = ConstManager.calculate_charge_rate(GameManager.stats_temp["Power"])
			var cooldown_rate = ConstManager.calculate_cooldown_rate(GameManager.stats_temp["Combo"]) + ConstManager.calculate_cooldown_rate(GameManager.stats_temp["Power"]) 
			set_skills_modified("ChargeRate",charge_rate)
			set_skills_modified("CooldownRate",cooldown_rate)
		"Armor":
			var damage_reduction = ConstManager.calculate_damage_reduction(GameManager.stats_temp["Armor"]) 
			set_skills_modified("DamageReduction",damage_reduction)
		"Attack":
			var bullet_damage = ConstManager.calculate_bullet_damage(GameManager.stats_temp["Attack"])
			var shooting_rate = ConstManager.calculate_shooting_rate(GameManager.stats_temp["Attack"]) +  ConstManager.calculate_shooting_rate(GameManager.stats_temp["Speed"])
			set_skills_modified("BulletDamage",bullet_damage)
			set_skills_modified("ShootingRate",shooting_rate)
		"Combo":
			var combo_rate = ConstManager.calculate_combo_rate(GameManager.stats_temp["Combo"]) 
			var cooldown_rate = ConstManager.calculate_cooldown_rate(GameManager.stats_temp["Combo"]) + ConstManager.calculate_cooldown_rate(GameManager.stats_temp["Power"]) 
			set_skills_modified("CooldownRate",cooldown_rate)
			set_skills_modified("ComboRate",combo_rate)
		"Speed":
			var rotation_speed = ConstManager.calculate_rotation_speed(GameManager.stats_temp["Speed"]) 
			var shooting_rate = ConstManager.calculate_shooting_rate(GameManager.stats_temp["Attack"]) +  ConstManager.calculate_shooting_rate(GameManager.stats_temp["Speed"])
			set_skills_modified("RotationSpeed",rotation_speed)
			set_skills_modified("ShootingRate",shooting_rate)
	
func parse_to_round_int(_value : float) -> int:
	return int(_value * 100)

func set_skills_modified(_skill_name : String, _value : float) -> void:
	get_skill(_skill_name).set_skill_value(str(parse_to_round_int(_value)))
	get_skill(_skill_name).set_modifed_value()
	
onready var health_value_label = $Panel/VBoxContainer/Health/Panel/HBoxContainer/HealthValue
onready var bttn_add_health = $Panel/VBoxContainer/Health/Panel/HBoxContainer/Buttons/AddHealth
onready var bttn_sub_health = $Panel/VBoxContainer/Health/Panel/HBoxContainer/Buttons/SubHealth
onready var cost_label = $Panel/VBoxContainer/Health/Panel/HBoxContainer/Cost/CostValue
var health_value : int
var inital_health : int
export var xp_base_cost : int = 1000
export var xp_increment : int = 100
export var health_clicks : int = 0

func set_health_value() -> void:
	health_value = int(GameManager.player_health)
	inital_health = int(GameManager.player_health)
	cost_label.text = str(calc_xp_health_cost())
	set_health_value_label()
	enable_buttons()

func set_health_value_label() -> void:
	health_value_label.text = str(health_value)

func _on_AddHealth_pressed() -> void:
	health_value += 10
	xp -= calc_xp_health_cost()
	health_clicks += 1
	update_health()

func _on_SubHealth_pressed() -> void:
	health_value -= 10
	health_clicks -= 1
	xp += calc_xp_health_cost()	
	update_health()

func update_health() -> void:
	health_clicks  = int(clamp(health_clicks, 0, 1000))
	health_value = int(clamp(health_value, ConstManager.MIN_HEALTH, ConstManager.MAX_HEALTH))
	xp_value.text = "0" if xp < 0 else str(xp)
	GameManager.temp_player_health = health_value
	GameManager.temp_player_xp = xp
	cost_label.text = str(calc_xp_health_cost())
	set_health_value_label()
	validate_req_xp()
	enable_buttons()

func calc_xp_health_cost() -> int:
	return xp_base_cost + (health_clicks * xp_increment)
	
func can_get_health() -> bool:
	if  calc_xp_health_cost() > xp:
		return false
	return true

func enable_buttons() -> void:
	bttn_add_health.disabled = health_value == ConstManager.MAX_HEALTH or not can_get_health()
	bttn_sub_health.disabled = health_value == 10 or inital_health == health_value
