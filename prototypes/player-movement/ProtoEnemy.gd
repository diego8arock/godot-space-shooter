extends Area2D

var rotate_speed: float = 2.0
var radius: float = 150
var centre
var angle = 0 

export (NodePath) var player_path
var player

func _ready():
	
	player = get_node(player_path)
	
	centre = player.global_position
	
	pass


func _process(delta: float) -> void:
	
	angle += (rotate_speed / ProtoAutoload.time_flow) * delta
	centre = player.global_position
	var offset = Vector2(sin(angle), cos(angle)) * radius
	var pos = centre - offset
	global_position = pos
