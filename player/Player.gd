extends Node2D
class_name Player, "res://player/Player.gd"

export var debug : bool = true
export var charge_rate : float = 1.5
export var cooldown_rate : float = 0.5
export var super_shoot_multiplier : float = 2.0
export var combo_rate : float = 20.5
export var health : float = 100.0
export var stats_base : Resource

var rotation_angle : float = -90

var combo_value : float = 0.0
var combo_level : int = 0
var actual_charge : float = 0.0
var is_charging : bool = false
var is_charge_possible : bool = true

var give_control : bool = false
var rotate_to_end_point : bool = false

var radius_x : float
var radius_y : float

onready var bullet : PackedScene = preload("res://weapons/bullet/mid_bullet/MidBullet.tscn")
onready var super_bullet : PackedScene = preload("res://weapons/bullet/super_bullet/SuperBullet.tscn")
onready var explosion : PackedScene = preload("res://particles/BulletExplosion.tscn")

onready var shoot_sound = preload("res://sounds/laser6.ogg")
onready var super_shoot_sound = preload("res://sounds/laser3.ogg")

onready var pivot = $Pivot
onready var muzzle = $Pivot/Ship/Muzzle
onready var crosshair = $Pivot/Ship/Muzzle/Sprite
onready var aim_to = $Pivot/Ship/AimTo
onready var viewport_width = get_viewport().size.x
onready var viewport_height = get_viewport().size.y
onready var ship_collision = $Pivot/Ship/CollisionPolygon2D
onready var ship_radius = $Pivot/Ship/CollisionShape2D.shape.radius
onready var debug_stats_pivot = $Pivot/DebugPivot
onready var debug_stats = $Pivot/DebugPivot/PlayerStatsDebug
onready var stats = $Stats
onready var ship = $Pivot/Ship
onready var exit_position = $Pivot/ExitPosition
onready var tween = $Tween

signal update_health(_value)
signal update_power(_value)
signal update_combo(_value)
signal update_combo_level(_value)
signal update_xp(_value)
signal player_died()

func _init() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS

func _ready() -> void:
	stats.initialize(stats_base)
	$AudioShoot.stream = shoot_sound
	$AudioSuperShoot.stream = super_shoot_sound
	GameManager.enemy_aim_to = aim_to
	GameManager.player_pivot = pivot
	GameManager.player_health = int(health)
	radius_x = ship_radius * scale.x
	radius_y = ship_radius * scale.y
	if GameManager.use_crosshair_as_pivot:
		set_player_position()
		pivot.rotation += deg2rad(-90)
		crosshair.visible = false
	else:
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
				actual_charge += stats.charge_rate
				actual_charge = clamp(actual_charge, ConstManager.MIN_CHARGE, ConstManager.MAX_CHARGE)
			emit_signal("update_power", ConstManager.MAX_CHARGE - actual_charge)
		else:
			if actual_charge > ConstManager.MIN_CHARGE:
				actual_charge -= stats.cooldown_rate
				actual_charge = clamp(actual_charge, ConstManager.MIN_CHARGE, ConstManager.MAX_CHARGE)
			is_charge_possible = actual_charge == ConstManager.MIN_CHARGE
			is_charging = false
			DebugManager.debug("player-charge", actual_charge, debug)
			emit_signal("update_power", ConstManager.MAX_CHARGE - actual_charge)
			
		if Input.is_mouse_button_pressed(BUTTON_RIGHT):
			rotation_angle += stats.rotation_speed
			$Pivot/Ship/FireThrustLeft.start()
		else:
			$Pivot/Ship/FireThrustLeft.stop()
			
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			rotation_angle -= stats.rotation_speed
			
			$Pivot/Ship/FireThrustRight.start()
		else:
			$Pivot/Ship/FireThrustRight.stop()	

func _physics_process(delta: float) -> void:
	
	if GameManager.use_crosshair_as_pivot:
		pivot.look_at(GameManager.crosshair.global_position)
		set_player_position()
		debug_stats_pivot.global_rotation = 0
	else:
		pivot.global_rotation = rotation_angle * delta

func set_player_position() -> void:	
	
	pivot.global_position = GameManager.crosshair.get_line_end_position().global_position
	if give_control:
		pivot.global_position.x = clamp(pivot.global_position.x, radius_x, viewport_width - radius_x)
		pivot.global_position.y = clamp(pivot.global_position.y, radius_y, viewport_height - radius_y)

func _input(event: InputEvent) -> void:	

	if not GameManager.use_crosshair_as_pivot and GameManager.is_player_alive and event is InputEventMouseMotion:
		DebugManager.debug("event-mouse", event.relative, debug)
		global_position += event.relative
		global_position.x = clamp(global_position.x, radius_x, viewport_width - radius_x)
		global_position.y = clamp(global_position.y, radius_y, viewport_height - radius_y)	

	if event is InputEventKey:
		if event.is_action_released("player_shoot"):
			super_shoot()

func _on_ShootTimer_timeout() -> void:
	if GameManager.is_player_alive and not is_charging and give_control:
		var new_bullet : BaseBullet = bullet.instance()
		new_bullet.initialize( stats.bullet_damage, self,  WeaponManager.GROUP_WEAPON_PLAYER) 
		$AudioShoot.play()
		shoot(new_bullet)

func super_shoot() -> void:
	var new_super_bullet : BaseBullet = super_bullet.instance()
	new_super_bullet.initialize(calculate_super_bullet_damage(), self,  WeaponManager.GROUP_WEAPON_PLAYER) 
	DebugManager.debug("new_super_bullet.weapon_damage", new_super_bullet.weapon_damage, debug)
	$AudioSuperShoot.play()
	shoot(new_super_bullet)
	
func calculate_super_bullet_damage() -> float:
	var percentage : float = actual_charge / 100
	var real_multiplier : float = super_shoot_multiplier * percentage
	var real_damage  : float = stats.bullet_damage * real_multiplier
	return real_damage

func shoot(new_bullet : BaseBullet) -> void:
	WeaponManager.add_weapon(new_bullet, scale.x, scale.y)
	var direction = Vector2(1, 0).rotated(muzzle.global_rotation)
	new_bullet.shoot(muzzle.global_position, direction)		

func _on_Ship_take_damage(_value) -> void:
	if health > ConstManager.MIN_HEALTH:
		
		GameManager.create_bullet_explosion(pivot.global_position)
				
		combo_level -= 1
		combo_level = int(clamp(combo_level, 0, 100))
		emit_signal("update_combo_level", combo_level)

		combo_value = ConstManager.MIN_COMBO
		emit_signal("update_combo", combo_value)
		
		var real_health_loss = _value - (_value * stats.damage_reduction)
		DebugManager.debug(name + "-health-loss", real_health_loss)
		health -= real_health_loss
		health = clamp(health, ConstManager.MIN_HEALTH, ConstManager.MAX_HEALTH)
		emit_signal("update_health", health)
		GameManager.player_health = int(health)
		if health <= ConstManager.MIN_HEALTH:		
			GameManager.player_last_position = pivot.global_position
			emit_signal("player_died")			
		
func on_Game_player_died() -> void:
	give_control = false
	hide()
		
func on_Game_player_respawned() -> void:
	show()	
	health = ConstManager.MAX_HEALTH
	emit_signal("update_health", ConstManager.MAX_HEALTH)
	$Pivot/Ship.show()
	
func on_NPC_got_hit(_value) -> void:
	increase_combo_level(false)
	
func on_NPC_died(_xp) -> void:
	DebugManager.debug(name + str(GameManager.player_xp), "on_NPC_died")
	increase_combo_level(true)
	GameManager.player_xp += _xp * (1 if combo_level == 0 else combo_level)
	emit_signal("update_xp", GameManager.player_xp)	

func increase_combo_level(npc_dead : bool = false) -> void:
	var value_to_add : float = stats.combo_rate * (3.5 if npc_dead else 1.0)
	var value_to_sub : float = value_to_add * get_combo_decreaser()
	var real_value : float = value_to_add - value_to_sub
	combo_value += real_value
	combo_value = clamp(combo_value, ConstManager.MIN_COMBO, ConstManager.MAX_COMBO)
	if combo_value >= ConstManager.MAX_COMBO:
		combo_value = ConstManager.MIN_COMBO
		combo_level += 1 if combo_level < ConstManager.MAX_COMBO_LEVEL else 0
		emit_signal("update_combo_level",combo_level)
	emit_signal("update_combo", combo_value)

func get_combo_decreaser() -> float:
	return (0.001) * pow(combo_level, 2) + (0.02) * combo_level + (0.1)
		
	
func udpate_stats() -> void:
	
	stats.update_stats()
	
	debug_stats.add_stat("attack", stats.attack)
	debug_stats.add_stat("speed", stats.speed)
	debug_stats.add_stat("armor", stats.armor)
	debug_stats.add_stat("combo", stats.combo)
	debug_stats.add_stat("power", stats.power)
	
	debug_stats.add_stat("damage_reduction", stats.damage_reduction)
	debug_stats.add_stat("rotation_speed", stats.rotation_speed)
	debug_stats.add_stat("bullet_damage", stats.bullet_damage)
	debug_stats.add_stat("shooting_rate", stats.shooting_rate)
	debug_stats.add_stat("charge_rate", stats.charge_rate)
	debug_stats.add_stat("cooldown_rate", stats.cooldown_rate)
	debug_stats.add_stat("combo_rate", stats.combo_rate)
	
func get_rotation_speed() -> float:
	return stats.rotation_speed
	
func update_health() -> void:
	health = GameManager.player_health

func on_Game_countdown_finished() -> void:
	give_control = true

func on_Game_enemies_destroyed() -> void:
	give_control = false
	