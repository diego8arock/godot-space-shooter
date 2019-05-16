extends Area2D

export var turret_speed : float = 2.0
export var health : float = 100

const BUFFER_10 : int = 10
const ZERO_VALUE_FLOAT : float = 0.0

var states_stack = []
var current_state = null
# warning-ignore:unused_signal
signal state_changed(states_stack)

onready var gui = $EnemyGui
signal update_health(_value)

onready var states_map = {
	"idle" : $States/Idle,
	"shoot_bullets" : $States/ShootBullet,
	"shoot_missile" : $States/ShootMissile
}

func _ready():
# warning-ignore:return_value_discarded
	connect("update_health", gui, "update_healthbar")
	states_stack.push_back($States/Idle)
	current_state = states_stack[0]
	_change_state("idle")
	
func _process(delta):
	
	DebugManager.debug("turret-health", health, false)
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
	DebugManager.debug("turret-current_state", current_state.name)
	DebugManager.debug_states("turret-states", states_stack)

func _on_Turret_area_entered(area):
	if area.is_in_group(WeaponManager.GROUP_WEAPON_PLAYER):
		take_damage(area.weapon_damage)
		area.queue_free()

func take_damage(_value):	
	health -= _value
	emit_signal("update_health", health)
	
func evaluate_health():
	if health <= 0:
		queue_free()

func aim_at_player(_delta) -> void:		
	if  GameManager.enemy_aim_to:
		var target_dir = (GameManager.enemy_aim_to.global_position - global_position).normalized()
		var current_dir = Vector2(1, 0).rotated($Pivot.global_rotation)
		$Pivot.global_rotation = current_dir.linear_interpolate(target_dir, turret_speed * _delta).angle()	
