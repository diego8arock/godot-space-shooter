extends Node2D
class_name Player, "res://player/Player.gd"

export var debug : bool = true
export var charge_rate : float = 1.5
export var cooldown_rate : float = 0.5
export var super_shoot_multiplier : float = 2.0
export var combo_rate : float = 20.5
export var health : float = 100.0

var xp : int = 0
var combo_value : float = 0.0
var combo_level : int = 0
var actual_charge : float = 0.0
var is_charging : bool = false
var is_charge_possible : bool = true

var radius_x : float
var radius_y : float

var bullet : PackedScene = preload("res://weapons/bullet/mid_bullet/MidBullet.tscn")
var super_bullet : PackedScene = preload("res://weapons/bullet/super_bullet/SuperBullet.tscn")

onready var pivot = $Pivot
onready var muzzle = $Pivot/Ship/Muzzle
onready var aim_to = $Pivot/Ship/AimTo
onready var viewport_width = get_viewport().size.x
onready var viewport_height = get_viewport().size.y
onready var ship_collision = $Pivot/Ship/CollisionPolygon2D
onready var ship_radius = $Pivot/Ship/CollisionShape2D.shape.radius

signal update_health(_value)
signal update_power(_value)
signal update_combo(_value)
signal update_combo_level(_value)
signal update_xp(_value)
signal player_died(_position)

func _init() -> void:
	pause_mode = Node.PAUSE_MODE_STOP

func _ready() -> void:
	GameManager.enemy_aim_to = aim_to
	radius_x = ship_radius * scale.x
	radius_y = ship_radius * scale.y
	set_player_position()
	pivot.rotation += deg2rad(-90)
	connect("update_health", GameManager.player_gui, "on_Player_update_health")
	connect("update_power", GameManager.player_gui, "on_Player_update_power")
	connect("update_combo", GameManager.player_gui, "on_Player_update_combo")
	connect("update_combo_level", GameManager.player_gui, "on_Player_update_combo_level")
	connect("update_xp", GameManager.player_gui, "on_Player_update_xp")
	connect("player_died", GameManager.game, "on_Player_player_died")

func _process(delta: float) -> void:
	
	if GameManager.is_player_alive:
		if Input.is_key_pressed(KEY_SPACE) and is_charge_possible:
			DebugManager.debug("player-charge", actual_charge, debug)
			is_charging = true
			if actual_charge < ConstManager.MAX_CHARGE:
				actual_charge += charge_rate
				actual_charge = clamp(actual_charge, ConstManager.MIN_CHARGE, ConstManager.MAX_CHARGE)
			emit_signal("update_power", ConstManager.MAX_CHARGE - actual_charge)
		else:
			if actual_charge > ConstManager.MIN_CHARGE:
				actual_charge -= cooldown_rate
				actual_charge = clamp(actual_charge, ConstManager.MIN_CHARGE, ConstManager.MAX_CHARGE)
			is_charge_possible = actual_charge == ConstManager.MIN_CHARGE
			is_charging = false
			DebugManager.debug("player-charge", actual_charge, debug)
			emit_signal("update_power", ConstManager.MAX_CHARGE - actual_charge)
			
		if Input.is_mouse_button_pressed(BUTTON_RIGHT):
			$Pivot/Ship/FireThrustLeft.start()
		else:
			$Pivot/Ship/FireThrustLeft.stop()
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			$Pivot/Ship/FireThrustRight.start()
		else:
			$Pivot/Ship/FireThrustRight.stop()	

func _physics_process(delta: float) -> void:
	
	pivot.look_at(GameManager.crosshair.global_position)
	set_player_position()

func set_player_position() -> void:	
	
	pivot.global_position = GameManager.crosshair.get_line_end_position().global_position
	pivot.global_position.x = clamp(pivot.global_position.x, radius_x, viewport_width - radius_x)
	pivot.global_position.y = clamp(pivot.global_position.y, radius_y, viewport_height - radius_y)

func _input(event: InputEvent) -> void:	

	if event is InputEventKey:
		if event.is_action_released("player_shoot"):
			super_shoot()

func _on_ShootTimer_timeout() -> void:
	if GameManager.is_player_alive and not is_charging:
		var new_bullet : BaseBullet = bullet.instance()
		new_bullet.initialize( WeaponManager.PLAYER_BULLET_DAMAGE_BASE, self,  WeaponManager.GROUP_WEAPON_PLAYER) 
		shoot(new_bullet)

func super_shoot() -> void:
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
	if health > ConstManager.MIN_HEALTH:		
		combo_level -= 1.0
		combo_level = clamp(combo_level, 0, 100)
		emit_signal("update_combo_level", combo_level)
		
		combo_value = ConstManager.MIN_COMBO
		emit_signal("update_combo", combo_value)
		
		health -= _value
		health = clamp(health, ConstManager.MIN_HEALTH, ConstManager.MAX_HEALTH)
		emit_signal("update_health", health)
		if health <= ConstManager.MIN_HEALTH:
			emit_signal("player_died", aim_to.global_position)
		
func on_Game_player_died() -> void:
	hide()
		
func on_Game_player_respawned(_position) -> void:
	show()	
	emit_signal("update_health", ConstManager.MAX_HEALTH)
	health = ConstManager.MAX_HEALTH
	$Pivot/Ship.show()
	
func on_NPC_got_hit(_value) -> void:
	increase_combo_level(false)
	
func on_NPC_died(_value) -> void:
	increase_combo_level(true)
	xp += _value
	emit_signal("update_xp", _value)	

func increase_combo_level(npc_dead : bool = false) -> void:
	combo_value += combo_rate * (3.5 if npc_dead else 1)
	combo_value = clamp(combo_value, ConstManager.MIN_COMBO, ConstManager.MAX_COMBO)
	if combo_value >= ConstManager.MAX_COMBO:
		combo_value = ConstManager.MIN_COMBO
		combo_level += 1
		emit_signal("update_combo_level",combo_level)
	emit_signal("update_combo", combo_value)
	

	
	
	