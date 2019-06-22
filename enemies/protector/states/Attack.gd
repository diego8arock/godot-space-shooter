extends State

export var spheres_container_path : NodePath
var spheres_container : Node2D

var speed: float = 50.0
var steer_force: float = 3.0

var new_state = null
var sphere_index = 0

var attack_timer : float = 0.0

func _ready() -> void:
	spheres_container = get_node(spheres_container_path)

func enter(_host: Node2D) -> void:
	if _host.level < 3:
		attack_timer = 4
	elif _host.level >= 3 and _host.level < 9:
		attack_timer = 3
	elif _host.level >= 8 and _host.level < 20:
		attack_timer = 3
	else:
		attack_timer = 2
	$Timer.start()
	$AttackTimer.start(attack_timer)
	
func exit(_host: Node2D) -> void:
	return
	
func handle_input(_host: Node2D, _event) -> void:
	return

func update(_host: Node2D, _delta: float) -> String:
	
	if new_state:
		return new_state
	
	_host.steer(_delta, speed, steer_force)
	
	return ConstManager.EMPTY_STRING
	
func fixed_update(_host: Node2D, _delta: float) -> String:
	return ConstManager.EMPTY_STRING

func _on_Timer_timeout() -> void:
	$AttackTimer.stop()
	new_state = "idle"

func _on_AttackTimer_timeout() -> void:
	var s = spheres_container.get_child(sphere_index)
	sphere_index += 1
	while not s is Sphere:
		if sphere_index == spheres_container.get_child_count():
			sphere_index = 0
		s = spheres_container.get_child(sphere_index)
		sphere_index += 1
	s.change_action(Sphere.ACTION.ATTACK)
	$AttackTimer.start()
