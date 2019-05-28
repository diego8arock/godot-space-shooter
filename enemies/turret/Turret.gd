extends NPC

export var debug : bool = false

const BUFFER_10 : int = 10
const ZERO_VALUE_FLOAT : float = 0.0

var states_stack = []
var current_state = null
signal state_changed(states_stack)

onready var states_map = {
	"idle" : $States/Idle,
	"shoot_bullets" : $States/ShootBullet,
	"shoot_missile" : $States/ShootMissile
}

func _ready():
	._ready()
	states_stack.push_back($States/Idle)
	current_state = states_stack[0]
	_change_state("idle")
	
func _process(delta):
	
	DebugManager.debug("turret-health", health, debug)
	evaluate_health()

	call_deferred("aim_at_player", delta)
	
	var state_name = current_state.update(self, delta)	
	if state_name and not state_name.empty():
		_change_state(state_name)
		
func _physics_process(delta: float) -> void:
	
	var state_name = current_state.fixed_update(self, delta)
	if state_name and not state_name.empty():
		_change_state(state_name)
		
func _change_state(_state_name) -> void:
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

func _on_Turret_area_entered(area):
	if area.is_in_group(WeaponManager.GROUP_WEAPON_PLAYER):
		take_damage(area.weapon_damage)
		area.queue_free()

func aim_at_player(_delta) -> void:		
	if  GameManager.is_enemy_to_attack():
		var target_dir = (GameManager.enemy_aim_to.global_position - global_position).normalized()
		var current_dir = Vector2(1, 0).rotated($Pivot.global_rotation)
		$Pivot.global_rotation = current_dir.linear_interpolate(target_dir, stats.speed * _delta).angle()	
