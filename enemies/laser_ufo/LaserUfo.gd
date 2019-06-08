extends NPC

export var debug : bool = true

var states_stack = []
var current_state = null

onready var states_map = {
	"fly" : $States/Fly,
	"attack" : $States/Attack
}

onready var laser_container = $LaserContainer
onready var shield = $Sprite/LaserUfoShield

func _ready() -> void:
	._ready()
	states_stack.push_back($States/Attack)
	current_state = states_stack[0]
	_change_state("attack")
	
func _process(delta: float) -> void:
		
	evaluate_health()
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

func _on_LaserUfo_area_entered(area: Area2D) -> void:
	process_area_entered(area)
