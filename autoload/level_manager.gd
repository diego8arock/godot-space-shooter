extends Node

var turret = preload("res://enemies/turret/Turret.tscn")

var levels_file = "res://json/levels.json"
var levels

func load_levels() -> void:
	var file = File.new()
	file.open(levels_file, File.READ)
	levels = parse_json(file.get_as_text())
	GameManager.max_level = levels.size()
	
func load_level_enemies(id : int) -> Array:
	var level_enemies = []
	var enemies = levels[str(id)]
	for e in enemies:
		if e.type == "turret":
			var el = EnemyLoader.new()
			el.npc = turret.instance() as NPC
			el.pos = e.pos
			el.row = e.row
			level_enemies.push_back(el)
	return level_enemies
	
