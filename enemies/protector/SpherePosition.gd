extends Position2D

var rotate_speed: float = 2.0
var radius: float
var centre
var angle = 0 

func _ready():
	centre = get_parent().position
	$Sprite.hide()
	pass

func _process(delta: float) -> void:
	
	angle += rotate_speed * delta

	var offset = Vector2(sin(angle), cos(angle)) * radius
	var pos = centre - offset
	position = pos
