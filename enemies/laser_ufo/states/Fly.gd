extends State

var path = ["R1-P1", "R2-P10", "R9-P1", "R10-P10", "R5-P6"]
var tween : Tween
var initial_pos : Position2D
var final_pos : Position2D
var continue_moving : bool = false
var path_index : int = 0
var velocity = Vector2()

func enter(_host: Node2D) -> void:
	.enter(_host)
	tween = _host.get_node("Tween")
	continue_moving = true
	path_index = 0

func exit(_host: Node2D) -> void:
	.exit(_host)

func update(_host: Node2D, _delta: float) -> String:	
	
	_host.global_position += velocity * _delta	
	
	if continue_moving: 
	
		if path_index == path.size():
			return "attack"
			
		var end = path[path_index].split("-")
		final_pos = GameManager.grid.get_grid_position(end[0], end[1])
		
		move_to_position(_host, final_pos.global_position)		
	
	if ConstManager.distance_to_target(_host.global_position, final_pos.global_position) <= 50.0:
		continue_moving = true
		path_index += 1	
	
	return ConstManager.EMPTY_STRING
	
func move_to_position(_host: Node2D, final: Vector2) -> void:
	var dir: Node2D = _host.get_node("Direction")
	dir.look_at(final)
	velocity = Vector2(1,0).rotated(dir.global_rotation) * 100
	continue_moving = false


	

