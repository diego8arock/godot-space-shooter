extends Node

export var speed : float
export (ConstManager.STAT_MODIFIER) var speed_modifier
export var attack : float
export (ConstManager.STAT_MODIFIER) var attack_modifier
export var defense : float
export (ConstManager.STAT_MODIFIER) var defense_modifier
export var xp : int
export (ConstManager.STAT_MODIFIER) var xp_modifier

func initialize(_stats : NpcStartingStats) -> void:
	if _stats:
		xp = _stats.xp 
		speed = _stats.speed
		attack = _stats.attack
		defense = _stats.defense
		speed_modifier = _stats.speed_modifier
		attack_modifier = _stats.attack_modifier
		defense_modifier = _stats.defense_modifier
		xp_modifier = _stats.xp_modifier
	else:
		WarningManager.warn(name, "no stats added")
		
func adjust_by_level(_level : int) -> void:
	xp = int(xp * get_level_multiplier(_level, xp_modifier))
	speed = speed * get_level_multiplier(_level, speed_modifier)
	attack = attack * get_level_multiplier(_level, attack_modifier)
	defense = defense * get_level_multiplier(_level, defense_modifier)
		
func get_level_multiplier(_level : int, _modifier) -> float:
	var constants = get_multiplier_constants(_modifier)
	var multi = constants[0] * _level + constants[1]
	return constants[0] * _level + constants[1] # a * x + b
	
func get_multiplier_constants(_modifier) -> Array:
	var values = []
	var v_1
	var v_2
	match _modifier:
		ConstManager.STAT_MODIFIER.BY_01:
			v_1 = 0.01 
			v_2 = 0.99
		ConstManager.STAT_MODIFIER.BY_05: 
			v_1 = 0.05
			v_2 = 0.95
		ConstManager.STAT_MODIFIER.BY_1: 
			v_1 = 0.1 
			v_2 = 0.9
		ConstManager.STAT_MODIFIER.BY_2: 
			v_1 = 0.2
			v_2 = 0.8
		ConstManager.STAT_MODIFIER.BY_3: 
			v_1 = 0.3 
			v_2 = 0.7
		ConstManager.STAT_MODIFIER.BY_4: 
			v_1 = 0.4 
			v_2 = 0.6
		ConstManager.STAT_MODIFIER.BY_5: 
			v_1 = 0.5 
			v_2 = 0.5
		ConstManager.STAT_MODIFIER.BY_6: 
			v_1 = 0.6 
			v_2 = 0.4
		ConstManager.STAT_MODIFIER.BY_7: 
			v_1 = 0.7 
			v_2 = 0.3
		ConstManager.STAT_MODIFIER.BY_8: 
			v_1 = 0.8 
			v_2 = 0.2
		ConstManager.STAT_MODIFIER.BY_9:
			v_1 = 0.9 
			v_2 = 0.1		
	values.push_back(v_1)
	values.push_back(v_2)
	return values

# by .01 = 0.01x + 0.99
# by .05 = 0.05x + 0.95
# by .1 = 0.1x + 0.9
# by .2 = 0.2x + 0.8
# by .3 = 0.3x + 0.7
# by .4 = 0.4x + 0.6
# by .5 = 0.5x + 0.5
# by .6 = 0.6x + 0.4
# by .7 = 0.7x + 0.3
# by .8 = 0.8x + 0.2
# by .9 = 0.9x + 0.1


