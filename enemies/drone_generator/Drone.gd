extends NPC

export var debug : bool = false

var states_stack = []
var current_state = null

onready var states_map = {
	"fly" : $States/Fly,
	"shoot" : $States/Shoot
}

var exit_point : Position2D

func _ready() -> void:
	._ready()
	states_stack.push_back($States/Fly)
	current_state = states_stack[0]
	_change_state("fly")
	
func _process(delta: float) -> void:
		
	var state_name = current_state.update(self, delta)	
	if state_name and not state_name.empty():
		_change_state(state_name)	
	
func _change_state(_state_name : String) -> void:
	current_state.exit(self)
	
	if _state_name == "previous":
		states_stack.pop_front()
	else:
		var new_state = states_map[_state_name]
		states_stack[0] = new_state
	
	current_state = states_stack[0]
	if _state_name != "previous":
		current_state.enter(self)
	DebugManager.debug("turret-current_state", current_state.name, debug)
	DebugManager.debug_states("turret-states", states_stack, debug)

func _on_DroneGenerator_area_entered(area: Area2D) -> void:
	process_area_entered(area)
