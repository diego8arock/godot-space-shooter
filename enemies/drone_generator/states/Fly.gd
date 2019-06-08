extends State

var fly_destination : Position2D
var exit_point : Position2D
var tween : Tween
var ready_to_shoot : bool = false

func enter(_host: Node2D) -> void:
	.enter(_host)
	_host.global_rotation_degrees = 90
	tween = _host.get_node("Tween")
	exit_point = _host.exit_point
	fly_destination = GameManager.grid.get_random_free_position()	
	tween.interpolate_property(_host, "global_position", _host.global_position, exit_point.global_position, 1.0, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	var angle = _host.global_position.angle_to_point(fly_destination.global_position)
	tween.interpolate_property(_host, "global_rotation", _host.global_rotation, angle + deg2rad(180), 1.0, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	yield(tween, "tween_completed")
	tween.interpolate_property(_host, "global_position", _host.global_position, fly_destination.global_position, 1.5, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	ready_to_shoot = true

func exit(_host) -> void:
	.exit(_host)

func update(_host, _delta) -> String:

	if ready_to_shoot:
		return "shoot"
	
	return ConstManager.EMPTY_STRING