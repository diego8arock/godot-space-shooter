extends NPC

export var debug : bool = false

var states_stack = []
var current_state = null

onready var explosion : PackedScene = preload("res://particles/BulletExplosion.tscn")

onready var states_map = {
	"idle" : $States/Idle,
	"shoot_bullets" : $States/ShootBullet,
	"shoot_missile" : $States/ShootMissile
}

func _ready() -> void:
	._ready()
	states_stack.push_back($States/Idle)
	current_state = states_stack[0]
	_change_state("idle")
	
func _process(delta: float) -> void:
	
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

func _on_Turret_area_entered(area: Area2D) -> void:
	process_area_entered(area)

func aim_at_player(_delta : float) -> void:		
	if  GameManager.is_enemy_to_attack():
		var target_dir = (GameManager.enemy_aim_to.global_position - global_position).normalized()
		var current_dir = Vector2(1, 0).rotated($Pivot.global_rotation)
		$Pivot.global_rotation = current_dir.linear_interpolate(target_dir, stats.speed * _delta).angle()	
