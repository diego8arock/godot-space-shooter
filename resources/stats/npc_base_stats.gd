extends Resource
class_name NpcStartingStats


export var npc_type : String = "Character"

export var speed : float
export (ConstManager.STAT_MODIFIER) var speed_modifier
export var attack : float
export (ConstManager.STAT_MODIFIER) var attack_modifier
export var defense : float
export (ConstManager.STAT_MODIFIER) var defense_modifier
export var xp : int
export (ConstManager.STAT_MODIFIER) var xp_modifier
