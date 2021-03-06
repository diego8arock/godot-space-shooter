extends Area2D

var player_debug
var font: Font = preload("res://assets/gui/player/health_dynamicfont.tres")

onready var player = get_parent().get_parent()

func _ready():
	player_debug = Label.new()
	player_debug.add_font_override("font", font)
	$Debug.add_child(player_debug)
	
func _process(delta: float) -> void:
	
	player_debug.text = str(player.speed)
	
	
	

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		global_position += event.relative
		
	
	