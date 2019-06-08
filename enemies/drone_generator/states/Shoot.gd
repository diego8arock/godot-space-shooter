extends State

export var bullet_scale : float

onready var bullet : PackedScene = preload("res://weapons/bullet/mid_bullet/MidBulletEnemy.tscn")
var muzzle
var host_scale

func enter(_host: Node2D) -> void:
	.enter(_host)
	muzzle = _host.muzzle
	host_scale = _host.scale
	$Timer.start()
	
func exit(_host: Node2D) -> void:
	.exit(_host)
	
func update(_host: Node2D, _delta: float) -> String:
	
	aim_at_player(_host, _delta)
	
	return ConstManager.EMPTY_STRING

func shoot_at_player():
	if GameManager.is_enemy_to_attack():
		var new_bullet : BaseBullet = bullet.instance()
		new_bullet.initialize(WeaponManager.ENEMY_BULLETS_DAMAGE_BASE, self, WeaponManager.GROUP_WEAPON_ENEMY)
		WeaponManager.add_weapon(new_bullet, host_scale.x * bullet_scale, host_scale.y * bullet_scale)
		var direction = Vector2(1, 0).rotated(muzzle.global_rotation)
		new_bullet.shoot(muzzle.global_position, direction)
		$Timer.start()
	else:
		WarningManager.warn("shoot_bullet", "no target assigned")

func aim_at_player(_host: Node2D, _delta : float) -> void:		
	if  GameManager.is_enemy_to_attack():
		var target_dir = (GameManager.enemy_aim_to.global_position - _host.global_position).normalized()
		var current_dir = Vector2(1, 0).rotated(_host.global_rotation) 
		_host.global_rotation = current_dir.linear_interpolate(target_dir, _host.stats.speed * _delta).angle()

func _on_Timer_timeout() -> void:
	shoot_at_player()
