extends Node2D

var follow : PathFollow2D

func _ready() -> void:
	set_process(false)

func path_add_old_life(_index : int, _old_life) -> void:
	var path = get_child(_index) as Path2D
	follow = path.get_child(0)
	follow.add_child(_old_life)
	set_process(true)
	
func _process(delta: float) -> void:
	follow.set_offset(follow.get_offset() + 10 * delta)
	
