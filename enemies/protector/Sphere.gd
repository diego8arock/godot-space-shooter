extends Area2D
class_name Sphere

var radius_offset: float = 50.0
var radius_offset_rate: float = 0.2
var radius_total_offset: float = 0.0
var rotate_speed: float = 2.0
var radius: float
var centre
var angle = 0
var is_offset_increasing : = true
var sphere_position

const IDLE_SPEED: float = 2.0
const PROTECT_SPEED: float = 8.0
const ATTACK_SPEED: float = 5.0

enum ACTION { IDLE, PROTECT, ATTACK, RETREAT }
var action = ACTION.IDLE

var is_attacking : bool = false
var is_retreating : bool = false

var attack_velocity: Vector2
var last_aim_position: Vector2
const DISTANCE_THRESHOLD: float = 30.0
onready var sprite_attack = $SpriteAttack
onready var sprite_protect = $SpriteProtect
onready var adjust_position_timer = $PosAdjustTimer
var adjust_position: bool = false

onready var shockwave = $Shockwave
onready var animation = $AnimationPlayer
onready var trail = $Trail

func _ready():
	centre = get_parent().position

func _process(delta: float) -> void:
	
	#Always calculate angle for sphere position adjustment
	angle += rotate_speed * delta
	
	match action:
		ACTION.IDLE:
			idle(delta)
		ACTION.PROTECT:
			protect(delta)
		ACTION.ATTACK:
			attack(delta)
		ACTION.RETREAT:
			retreat(delta)
		_:
			return

func change_action(_action) -> void:
	match _action:
		ACTION.IDLE:
			rotate_speed = IDLE_SPEED
			sphere_position.rotate_speed = IDLE_SPEED
			trail.show()
			sprite_attack.hide()
			sprite_protect.hide()
		ACTION.PROTECT:
			rotate_speed = PROTECT_SPEED
			sphere_position.rotate_speed = PROTECT_SPEED
			sprite_attack.hide()
			sprite_protect.show()
		ACTION.ATTACK:
			sprite_protect.hide()
			sprite_attack.show()
			yield(get_tree().create_timer(1.0), "timeout")
			calculate_attack_angle()
		ACTION.RETREAT:
			sprite_attack.hide()
			animation.play("retreat")
	action = _action

func caclulate_radius_offset() -> float:

	if int(radius) == int(radius - radius_total_offset):
		is_offset_increasing = true

	if int(radius - radius_offset) == int(radius - radius_total_offset):
		is_offset_increasing = false

	return radius_offset_rate * (1 if is_offset_increasing else -1)

func idle(_delta: float) -> void:

	if int(radius - radius_total_offset)  < int(radius):
		radius_total_offset -= radius_offset_rate

	set_position_offset()

func protect(_delta: float) -> void:

	radius_total_offset += caclulate_radius_offset()
	set_position_offset()
	
func set_position_offset() -> void:
	var offset = Vector2(sin(angle), cos(angle)) * (radius - radius_total_offset)
	var pos = centre - offset
	position = pos

func attack(_delta: float) -> void:
	global_position += attack_velocity * _delta * 300
	if ConstManager.distance_to_target(last_aim_position, global_position) <= 150:
		shockwave.play()

func calculate_attack_angle() -> void:
	last_aim_position = GameManager.enemy_aim_to.global_position
	look_at(last_aim_position)
	var rotate = Vector2(1, 0).rotated(global_rotation)
	attack_velocity = rotate * ATTACK_SPEED

func retreat(_delta: float) -> void:
	global_position = sphere_position.global_position

func _on_Sphere_area_entered(area: Area2D) -> void:
	if area.is_in_group(WeaponManager.GROUP_WEAPON_PLAYER):
		GameManager.create_bullet_on_shield_explosion(area.global_position)
		area.call_deferred("free")

func _on_Shockwave_body_entered(body: PhysicsBody2D) -> void:
	if body.name == ConstManager.BODY_SHIP_NAME:
		body.take_damage(10)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	shockwave.play_backwards()
	trail.hide()
	yield(get_tree().create_timer(1.0), "timeout")
	change_action(ACTION.RETREAT)

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "retreat":
		change_action(ACTION.IDLE)	
