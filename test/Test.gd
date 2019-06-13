extends Node2D

onready var player_scene : PackedScene = preload("res://player/Player.tscn")
onready var crosshair_scene : PackedScene = preload("res://crosshair/Crosshair.tscn")

func _ready():
	GameManager.enemy_container = $EnemyContainer
	GameManager.explosion_container = $ExplosionContainer
	GameManager.damage_container = $DamageContainer
	WeaponManager.weapon_container = $WeaponContainer
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	init_crosshair() 
	init_player()

func _unhandled_key_input(event):	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()		

func init_crosshair() -> void:
	var crosshair : Crosshair = crosshair_scene.instance()
	add_child(crosshair)
	crosshair.global_position = Vector2(200,200)
	crosshair.on_Game_countdown_finished()
	GameManager.crosshair = crosshair
	
func init_player() -> void:
	var player : Player = player_scene.instance()
	add_child(player)
	player.global_position = Vector2(200,400)
	player.on_Game_countdown_finished()
	GameManager.player = player
	GameManager.enemy_aim_to = player.aim_to
