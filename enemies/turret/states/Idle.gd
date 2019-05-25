extends State

var states = ["shoot_bullets", "shoot_missile"]
var new_state = null
var state_index = 0

func enter(_host) -> void:
	.enter(_host)
	new_state = null
	$Timer.start()

func exit(_host) -> void:
	.exit(_host)

func update(_host, _delta) -> String:
	
	if new_state:
		return new_state

	return ConstManager.EMPTY_STRING

func _on_Timer_timeout() -> void:
	if state_index == states.size():
		state_index = 0
	new_state = states[state_index]
	state_index += 1 

