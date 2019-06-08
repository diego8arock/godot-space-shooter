extends Node

var turret = preload("res://enemies/turret/Turret.tscn")
var drone_generator = preload("res://enemies/drone_generator/DroneGenerator.tscn")
var ufo_laser = preload("res://enemies/laser_ufo/LaserUfo.tscn")

var levels_file = "res://json/levels.json"
var levels

var unique_id : int = 0

func load_levels() -> void:
	var file = File.new()
	file.open(levels_file, File.READ)
	levels = parse_json(file.get_as_text())
	GameManager.max_level = levels.size()
	
func load_level_enemies(id : int) -> Array:
	var level_enemies = []
	var enemies = levels[str(id)]
	var el
	for e in enemies:
		unique_id += 1
		el = EnemyLoader.new()
		
		if e.type == "turret":			
			el.npc = turret.instance() as NPC
		if e.type == "dronegen":
			el.npc = drone_generator.instance() as NPC
		if e.type == "laserufo":
			el.npc = ufo_laser.instance() as NPC
		
		el.npc.level = int(e.level)
		el.npc.id = unique_id
		el.pos = e.pos
		el.row = e.row
		level_enemies.push_back(el)
	return level_enemies
	
