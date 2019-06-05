extends Node

#String const
const EMPTY_STRING = ""

#Node names
const GAME_NODE_NAME = "Game"
const DEBUG_NODE_NAME = "DebugInfo"
const WARNING_NODE_NAME = "Warning"
const WEPONS_NODE_NAME = "WeaponContainer"
const ENEMIES_NODE_NAME = "EnemyContainer"
const MANAGER_SUBSTRING = "Manager"
const PLAYER_INITIAL_POSITION  = "PlayerInitialPosition"

#Area and body const
const BODY_SHIP_NAME = "Ship"

#Actors
const MAX_HEALTH : float = 100.0
const MIN_HEALTH : float = 0.0
const MAX_CHARGE: float = 100.0
const MIN_CHARGE : float = 0.0
const MAX_COMBO : float = 100.0
const MIN_COMBO : float = 0.0
const MAX_COMBO_LEVEL : int = 40

enum STAT_MODIFIER { BY_01, BY_05, BY_1, BY_2, BY_3, BY_4, BY_5, BY_6, BY_7, BY_8, BY_9  }

func calculate_damage_reduction(_level : int) -> float:
	return sqrt(_level) / 65 #Max increase 15%
func calculate_rotation_speed(_level : int) -> float:
	return sqrt(_level) / 25 #Max damage reduction 40% 
func calculate_bullet_damage(_level : int) -> float: 
	return sqrt(_level) / 14.9 #Max increase 70%
func calculate_shooting_rate(_level : int) -> float: 
	return sqrt(_level) / 19.9 #Max increase 50%
func calculate_charge_rate(_level : int) -> float: 
	return sqrt(_level) / 10 #Max increase 100%
func calculate_cooldown_rate(_level : int) -> float:
	return sqrt(_level) / 99 #Max increase 10% each, total 20%
func calculate_combo_rate(_level : int) -> float:
	return sqrt(_level) / 49.8 #Max increase 20% each, total 40%
