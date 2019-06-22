extends State

export var shield_path : NodePath
var shield

var states = ["protect", "attack"]
var new_state = null
var state_index = 0

var speed: float = 100.0
var steer_force: float = 1.5

func _ready() -> void:
	shield = get_node(shield_path)

func enter(_host) -> void:
	.enter(_host)
	_host.set_sphere_action(Sphere.ACTION.IDLE)	
	new_state = null
	$Timer.start()

func exit(_host) -> void:
	.exit(_host)

func update(_host, _delta) -> String:
	
	_host.steer(_delta, speed, steer_force)
	
	var shape = shield.shape as CircleShape2D
	shape.radius = 0
	
	if new_state:
		return new_state

	return ConstManager.EMPTY_STRING

func _on_Timer_timeout() -> void:
	if state_index == states.size():
		state_index = 0
	new_state = states[state_index]
	state_index += 1 