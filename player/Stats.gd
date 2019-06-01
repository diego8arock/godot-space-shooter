extends Node

var speed : int
var armor : int
var attack : int
var combo : int
var power : int

var base_damage_reduction : float
var base_rotation_speed : float
var base_bullet_damage : float
var base_shooting_rate : float
var base_charge_rate : float
var base_cooldown_rate : float
var base_combo_rate : float

var damage_reduction : float 
var rotation_speed : float 
var bullet_damage : float 
var shooting_rate : float 
var charge_rate : float 
var cooldown_rate : float
var combo_rate : float 

func initialize(_stats : PlayerStartingStats) -> void:
	if _stats:
		damage_reduction = _stats.damage_reduction
		rotation_speed = _stats.rotation_speed
		bullet_damage = _stats.bullet_damage
		shooting_rate = _stats.shooting_rate
		charge_rate = _stats.charge_rate
		cooldown_rate = _stats.cooldown_rate
		combo_rate = _stats.combo_rate
		base_damage_reduction = _stats.damage_reduction
		base_rotation_speed = _stats.rotation_speed
		base_bullet_damage = _stats.bullet_damage
		base_shooting_rate = _stats.shooting_rate
		base_charge_rate = _stats.charge_rate
		base_cooldown_rate = _stats.cooldown_rate
		base_combo_rate = _stats.combo_rate
	else:
		WarningManager.warn(name, "no stats added")
		
func update_stats() -> void:
	
	attack = GameManager.stats["Attack"]
	speed = GameManager.stats["Speed"]
	armor = GameManager.stats["Armor"]
	combo = GameManager.stats["Combo"]
	power = GameManager.stats["Power"]
	
	rotation_speed = base_rotation_speed + (base_rotation_speed * ConstManager.calculate_rotation_speed(power)) #Max increase 15%
	damage_reduction = ConstManager.calculate_damage_reduction(armor) #Max damage reduction 40% 
	bullet_damage = base_bullet_damage + (base_bullet_damage * ConstManager.calculate_bullet_damage(attack)) #Max increase 70%
	charge_rate = base_charge_rate + (base_charge_rate * ConstManager.calculate_charge_rate(power)) #Max increase 50%
	combo_rate = base_combo_rate + (base_combo_rate * ConstManager.calculate_combo_rate(combo)) #Max increase 100%
	shooting_rate = base_shooting_rate + (base_shooting_rate  * ConstManager.calculate_shooting_rate(attack)) + (base_shooting_rate * ConstManager.calculate_shooting_rate(speed)) #Max increase 10% each, total 20%
	cooldown_rate = base_cooldown_rate + (base_cooldown_rate  * ConstManager.calculate_cooldown_rate(combo)) + (base_cooldown_rate * ConstManager.calculate_cooldown_rate(power)) #Max increase 20% each, total 40%
	
