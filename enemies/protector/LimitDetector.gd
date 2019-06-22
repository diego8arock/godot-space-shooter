extends Node2D

onready var parent = get_parent().get_parent()
onready var line = $Line2D

enum DIRECTION { TOP, LEFT, RIGHT, BOTTOM }
export (DIRECTION) var direction

var end_point: Vector2
var viewport_size

func _ready():
	viewport_size = get_viewport().size
	set_end_point()
	
func _process(delta: float) -> void:
	set_end_point()
	
func set_end_point() -> void:
	
	match direction:
		DIRECTION.TOP:
			end_point = Vector2(parent.global_position.x, 0)
		DIRECTION.LEFT:
			end_point = Vector2(0, parent.global_position.y)
		DIRECTION.RIGHT:
			end_point = Vector2(viewport_size.x, parent.global_position.y)
		DIRECTION.BOTTOM:
			end_point = Vector2(parent.global_position.x, viewport_size.y)

	line.points[1] = to_local(end_point)
	
func get_distance() -> float:
	return ConstManager.distance_to_target(line.points[0], line.points[1])
	