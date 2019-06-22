extends DraggablePanel

export (NodePath) var parent_path
var parent : Node2D

onready var enemy_simulator: PackedScene = preload("res://simulator/EnemySimulator.tscn")

onready var turret_stats: NpcStartingStats = preload("res://resources/stats/turret/turret_base_stats.tres")

onready var enemy_type_collection = $PanelContainer/VBoxContainer/TypeContainer/EnemyType
onready var level = $PanelContainer/VBoxContainer/LevelContainer/Level

onready var center = get_viewport().size / 2

var old_text

func _ready():
	$PanelContainer.connect("mouse_entered", self, "_on_PanelContainer_mouse_entered")
	$PanelContainer.connect("mouse_exited", self, "_on_PanelContainer_mouse_exited")
	
	parent = get_node(parent_path)
	old_text = level.text

func _on_CreateButton_pressed() -> void:
	var new_enemy_simulator = enemy_simulator.instance()	
	var type = enemy_type_collection.get_item_text(enemy_type_collection.selected)
	match type:
		"Turret":
			new_enemy_simulator.stats_resource = turret_stats
			new_enemy_simulator.level = int(level.text)
			new_enemy_simulator.enemy_type = type
		_:
			return
	parent.add_child(new_enemy_simulator)
	new_enemy_simulator.rect_global_position = center

func _on_Level_text_changed(new_text: String) -> void:
	if new_text.empty():
		return
	if new_text.is_valid_integer():
		old_text = new_text
	else:
		level.text = old_text


