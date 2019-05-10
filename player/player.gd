extends KinematicBody2D

var max_charge : float = 100.0
var min_charge : float = 0.0
var actual_charge : float = 0.0
var charge_rate : float = 1.5
var is_charging : bool = false
var is_charge_possible : bool = true

var bullet : PackedScene = preload("res://weapons/bullet/Bullet.tscn")
var super_bullet : PackedScene = preload("res://weapons/super_bullet/SuperBullet.tscn")

onready var muzzle = $Muzzle
onready var viewport_width = get_viewport().size.x
onready var viewport_height = get_viewport().size.y

const offset_x : float = 50.0
const offset_y : float = 50.0

func _ready():
	$AnimationPlayer.play("fly")
	GameManager.player = self

func _process(delta):
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and is_charge_possible:
		DebugManager.debug("player-charge", str(actual_charge))
		is_charging = true
		if actual_charge < max_charge:
			actual_charge += charge_rate
			actual_charge = clamp(actual_charge, min_charge, max_charge)
	else:
		if actual_charge > min_charge:
			actual_charge -= charge_rate
			actual_charge = clamp(actual_charge, min_charge, max_charge)
		is_charge_possible = actual_charge == min_charge
		is_charging = false
		DebugManager.debug("player-charge", str(actual_charge))

func _input(event):	
	if event is InputEventMouseMotion:
		global_position += event.relative
		global_position.x = clamp(global_position.x, offset_x , viewport_width - offset_x)
		global_position.y = clamp(global_position.y, offset_y, viewport_height - offset_y)

	if event is InputEventMouseButton:
		if event.is_action_released("ui_select"):
			super_shoot()

func _on_ShootTimer_timeout():
	if not is_charging:
		shoot(bullet.instance())

func super_shoot():
	shoot(super_bullet.instance())

func shoot(new_bullet) -> void:
	WeaponManager.add_weapon(new_bullet, 0.5, 0.5)
	var direction = Vector2(1, 0).rotated(muzzle.global_rotation)
	new_bullet.shoot(muzzle.global_position, direction)
	
