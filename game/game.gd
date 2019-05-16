extends Node2D
class_name Game

# warning-ignore:unused_class_variable
onready var player_init_position = $PlayerInitialPosition
onready var game_commander = $GameCommander
onready var enemy_container = $EnemyContainer

#Player
# warning-ignore:unused_class_variable
var crosshair : Crosshair
# warning-ignore:unused_class_variable
var player : Player
# warning-ignore:unused_class_variable
var player_gui

func _on_Screens_start_game() -> void:
	game_commander.game = self
	game_commander.execute()

	
	

