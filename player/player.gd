extends Node2D
class_name Player, "res://player/player.gd"

export var debug : bool = true
export var charge_rate : float = 1.5
export var cooldown_rate : float = 0.5
export var super_shoot_multiplier : float = 2.0
export var health : float = 100.0

var max_charge : float = 100.0
var min_charge : float = 0.0
var actual_charge : float = 0.0
var is_charging : bool = false
var is_charge_possible : bool = true
var radius_x : float
var radius_y : float

var bullet : PackedScene = preload("res://weapons/bullet/mid_bullet/MidBullet.tscn")
var super_bullet : PackedScene = preload("res://weapons/bullet/super_bullet/SuperBullet.tscn")

onready var crosshair = GameManager.crosshair
onready var pivot = $Pivot
onready var muzzle = $Pivot/Ship/Muzzle
onready var aim_to = $Pivot/Ship/AimTo
onready var viewport_width = get_viewport().size.x
onready var viewport_height = get_viewport().size.y
onready var ship_radius = $Pivot/Ship/CollisionShape2D.shape.radius

onready var player_gui = GameManager.player_gui
signal update_health(_value)
signal update_power(_value)

func _ready():
	$AnimationPlayer.play("fly")
	GameManager.enemy_aim_to = aim_to
	radius_x = ship_radius * scale.x
	radius_y = ship_radius * scale.y
# warning-ignore:return_value_discarded
	connect("update_health", player_gui, "update_healthbar")
# warning-ignore:return_value_discarded
	connect("update_power", player_gui, "update_powerbar")

# warning-ignore:unused_argument
func _process(delta):
	
	if Input.is_key_pressed(KEY_SPACE) and is_charge_possible:
		DebugManager.debug("player-charge", actual_charge, debug)
		is_charging = true
		if actual_charge < max_charge:
			actual_charge += charge_rate
			actual_charge = clamp(actual_charge, min_charge, max_charge)
		emit_signal("update_power", max_charge - actual_charge)
	else:
		if actual_charge > min_charge:
			actual_charge -= cooldown_rate
			actual_charge = clamp(actual_charge, min_charge, max_charge)
		is_charge_possible = actual_charge == min_charge
		is_charging = false
		DebugManager.debug("player-charge", actual_charge, debug)
		emit_signal("update_power", max_charge - actual_charge)	

# warning-ignore:unused_argument
func _physics_process(delta):
	
	if crosshair:
		pivot.look_at(crosshair.global_position)
		pivot.global_position = crosshair.get_line_end_position().global_position
		pivot.global_position.x = clamp(pivot.global_position.x, radius_x, viewport_width - radius_x)
		pivot.global_position.y = clamp(pivot.global_position.y, radius_y, viewport_height - radius_y)
	
func _input(event):

	if event is InputEventKey:
		if event.is_action_released("player_shoot"):
			super_shoot()

func _on_ShootTimer_timeout():
	if not is_charging:
		var new_bullet : BaseBullet = bullet.instance()
		new_bullet.initialize( WeaponManager.PLAYER_BULLET_DAMAGE_BASE, self,  WeaponManager.GROUP_WEAPON_PLAYER) 
		shoot(new_bullet)

func super_shoot():
	var new_super_bullet : BaseBullet = super_bullet.instance()
	new_super_bullet.initialize(calculate_super_bullet_damage(), self,  WeaponManager.GROUP_WEAPON_PLAYER) 
	DebugManager.debug("new_super_bullet.weapon_damage", new_super_bullet.weapon_damage, debug)
	shoot(new_super_bullet)
	
func calculate_super_bullet_damage() -> float:
	var percentage : float = actual_charge / 100
	var real_multiplier : float = super_shoot_multiplier * percentage
	var real_damage  : float = WeaponManager.PLAYER_SUPER_BULLET_DAMAGE_BASE * real_multiplier
	return real_damage

func shoot(new_bullet : BaseBullet) -> void:
	WeaponManager.add_weapon(new_bullet, scale.x, scale.y)
	var direction = Vector2(1, 0).rotated(muzzle.global_rotation)
	new_bullet.shoot(muzzle.global_position, direction)	

func _on_Ship_take_damage(_value) -> void:
	health -= _value
	emit_signal("update_health", health)
	die()
	
func die() -> void:
	if health <= 0:
		GameManager.process_player_death()
		call_deferred("free")