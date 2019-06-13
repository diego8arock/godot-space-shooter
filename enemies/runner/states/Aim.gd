extends State

const LINE_END_POS_Y :int = 3000

onready var lock_on = $LockOn

var speed : float
var line : Line2D
var aim_at_player : bool = false
var run_at_player : bool = false

var ray_cast : RayCast2D

func enter(_host: Node2D) -> void:
	speed = _host.stats.speed
	line = _host.get_node("Sprite").get_node("Line2D")
	ray_cast = _host.get_node("Sprite").get_node("RayCast2D")
	line.hide()	
	$AimTimer.start()
	
func exit(_host: Node2D) -> void:
	aim_at_player = false
	run_at_player = false
	
func handle_input(_host: Node2D, _event) -> void:
	return

func update(_host: Node2D, _delta: float) -> String:
	
	if run_at_player:
		return "run"
	
	if aim_at_player:
		aim(_host, _delta)
	
	return ConstManager.EMPTY_STRING
	

func aim(_host:Node2D, _delta: float) -> void:	
	
	if  GameManager.is_enemy_to_attack():
		var target_dir = (GameManager.enemy_aim_to.global_position - _host.global_position).normalized()
		var current_dir = Vector2(1, 0).rotated(_host.global_rotation)
		_host.global_rotation = current_dir.linear_interpolate(target_dir, speed * _delta).angle()
	
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider.name == ConstManager.BODY_SHIP_NAME:
			var local : Vector2 = line.to_local(collider.global_position)
			line.points[1] =  Vector2(line.points[1].x, local.y)
			lock_on.global_position = collider.global_position
			lock_on.show()
	else:
		line.points[1] = Vector2(line.points[1].x, LINE_END_POS_Y)
		lock_on.hide()

func _on_AimTimer_timeout() -> void:
	aim_at_player = true
	line.show()
	$RunTimer.start()

func _on_RunTimer_timeout() -> void:
	line.hide()	
	lock_on.hide()
	run_at_player = true
