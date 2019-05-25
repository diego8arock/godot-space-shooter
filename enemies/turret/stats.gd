extends Node

var xp : int
var speed : float
var attack : float
var defense : float

func initialize(_stats : NpcStartingStats) -> void:
	xp = _stats.xp
	speed = _stats.speed
	attack = _stats.attack
	defense = _stats.defense
