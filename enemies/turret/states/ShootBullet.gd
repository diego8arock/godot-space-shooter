extends State

export var max_bullets : int = 3
export var bullet_scale : float

onready var bullet : PackedScene = preload("res://weapons/bullet/mid_bullet/MidBulletEnemy.tscn")

var bullet_counter : int = 0
var muzzle = null
var host_scale = null

func enter(_host) -> void:
	.enter(_host)
	host_scale = _host.scale
	muzzle = _host.get_node("Pivot/Muzzle")
	$Cooldown.start()
	$Timer.start()
	
func exit(_host) -> void:
	.exit(_host)
	$Cooldown.stop()
	$Timer.stop()
	$Shoot.stop()
	
func update(_host, _delta) -> String:
	 
	if not execute_state:
		return "idle"
	
	return ConstManager.EMPTY_STRING

func shoot_at_player():
	if GameManager.is_enemy_to_attack():
		var new_bullet : BaseBullet = bullet.instance()
		new_bullet.initialize(WeaponManager.ENEMY_BULLETS_DAMAGE_BASE, self, WeaponManager.GROUP_WEAPON_ENEMY)
		WeaponManager.add_weapon(new_bullet, host_scale.x * bullet_scale, host_scale.y * bullet_scale)
		var direction = Vector2(1, 0).rotated(muzzle.global_rotation)
		new_bullet.shoot(muzzle.global_position, direction)
	else:
		WarningManager.warn("shoot_bullet", "no target assigned")

func _on_Cooldown_timeout():
	bullet_counter = 0
	$Shoot.start()

func _on_Shoot_timeout():
	if bullet_counter != max_bullets:
		shoot_at_player()
		bullet_counter += 1
	else:
		$Shoot.stop()
		$Cooldown.start()

func _on_Timer_timeout() -> void:
	execute_state = false
