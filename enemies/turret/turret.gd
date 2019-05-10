extends Area2D

export var turret_speed : float = 2.0
export var attack_precision : float = 0.00006

onready var bullet : PackedScene = preload("res://weapons/bullet/Bullet.tscn")
onready var player : KinematicBody2D = GameManager.player
onready var muzzle = $Pivot/Muzzle
onready var cooldown = $Cooldown

var array_close_to_target = []
var ready_to_shoot : bool = true

const BUFFER_10 : int = 10
const ZERO_VALUE_FLOAT : float = 0.0

func _process(delta):
	
	if not player:
		player = GameManager.player

	var target_dir = (player.global_position - global_position).normalized()
	var current_dir = Vector2(1, 0).rotated($Pivot.global_rotation)
	$Pivot.global_rotation = current_dir.linear_interpolate(target_dir, turret_speed * delta).angle()

	var close_to_target = atan2(muzzle.global_position.y - player.global_position.y, muzzle.global_position.x - player.global_position.x)
	DebugManager.debug("close_to_target", close_to_target)
	
	if array_close_to_target.size() == BUFFER_10:
		
		var median : float = ZERO_VALUE_FLOAT
		for c in array_close_to_target:
			median += c
		median /= BUFFER_10

		var estan_dev_sum : float = ZERO_VALUE_FLOAT
		for c in array_close_to_target:
			estan_dev_sum += abs(pow(c - median, 2))
		
		if abs(ZERO_VALUE_FLOAT - estan_dev_sum) <= attack_precision and ready_to_shoot:
			shoot_at_player()
			cooldown.start()
		
		array_close_to_target.pop_front();
	
	if array_close_to_target.size() < BUFFER_10:
		array_close_to_target.push_back(close_to_target)
		
	
func shoot_at_player():
	if player:
		var distance = sqrt(pow(player.global_position.x - global_position.x, 2) - pow(player.global_position.y - global_position.y, 2))
		var new_bullet = bullet.instance()
		WeaponManager.add_weapon(new_bullet, 0.5, 0.5)
		var direction = Vector2(1, 0).rotated(muzzle.global_rotation)
		new_bullet.shoot(muzzle.global_position, direction)
		ready_to_shoot = false


func _on_Cooldown_timeout():
	ready_to_shoot = true
