extends State

onready var missile : PackedScene = preload("res://weapons/missile/Missile.tscn")

var host_scale = null
var muzzle = null

func enter(_host) -> void:
	.enter(_host)
	host_scale = _host.scale
	muzzle = _host.get_node("Pivot/Muzzle")
	shoot_at_player()
	$Timer.start()
	
func exit(_host) -> void:
	.exit(_host)
	
func update(_host, _delta) -> String:
	 
	if not execute_state:
		return "idle"
	
	return ConstManager.EMPTY_STRING

func shoot_at_player():
	if GameManager.is_enemy_to_attack():
		var new_missile = missile.instance()
		new_missile.initialize(WeaponManager.ENEMY_MISSILE_DAMAGE_BASE, self, WeaponManager.GROUP_WEAPON_ENEMY)
		WeaponManager.add_weapon(new_missile, host_scale.x, host_scale.y)
		var direction = Vector2(1, 0).rotated(muzzle.global_rotation)
		new_missile.shoot(muzzle.global_position, direction)
		DebugManager.debug("missile-active", true, DebugManager.weapons_do_debug)
	else:
		WarningManager.warn("shoot_missile", "no target assigned")
		
func _on_signal_destroyed() -> void:
	DebugManager.debug("missile-active", false, DebugManager.weapons_do_debug)
	execute_state = false

func _on_Timer_timeout() -> void:
	execute_state = false
