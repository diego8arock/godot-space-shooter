extends State

var drone_container
onready var drone = preload("res://enemies/drone_generator/Drone.tscn")

func enter(_host) -> void:
	.enter(_host)
	drone_container = _host.get_node("DroneContainer")
	
	if drone_container.get_child_count() == 3:
		execute_state = false
		return
	
	var d = drone.instance()
	d.exit_point = _host.get_node("ExitPoint")
	d.z_index = 0
	drone_container.add_child(d)
		
	execute_state = false

func exit(_host) -> void:
	.exit(_host)

func update(_host, _delta) -> String:
	
	if not execute_state:
		return "idle"
		
	return ConstManager.EMPTY_STRING