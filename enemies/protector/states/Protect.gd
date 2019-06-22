extends State

export var shield_path : NodePath
var shield : CollisionShape2D

export var spheres_container_path : NodePath
var spheres_container : Node2D

var speed: float = 200.0
var steer_force : float = 0.75

var new_state = null

func _ready() -> void:
	shield = get_node(shield_path)
	spheres_container = get_node(spheres_container_path)
	
func enter(_host: Node2D) -> void:
	new_state = null
	_host.stop_shooting()
	_host.set_sphere_action(Sphere.ACTION.PROTECT)	
	$Timer.start()
	
func exit(_host: Node2D) -> void:
	_host.start_shooting()
	
func handle_input(_host: Node2D, _event) -> void:
	return

func update(_host: Node2D, _delta: float) -> String:
	
	if new_state:
		return new_state
	
	_host.steer(_delta, speed, steer_force)
	
	var shape = shield.shape as CircleShape2D
	var s = spheres_container.get_children()[0]		
	shape.radius = (s.radius - s.radius_total_offset)
	
	return ConstManager.EMPTY_STRING
	
func fixed_update(_host: Node2D, _delta: float) -> String:
	return ConstManager.EMPTY_STRING

func _on_Timer_timeout() -> void:
	new_state = "idle"
