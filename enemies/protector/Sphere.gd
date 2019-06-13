extends Area2D

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
const ATTACK_SPEED: float = 500.0

enum ACTION { IDLE, PROTECT, ATTACK, RETREAT }
var action = ACTION.IDLE

onready var tween_attack = $TweenAttack
onready var tween_retreat = $TweenRetreat

var is_attacking : bool = false
var is_retreating : bool = false

var attack_angle: float
var attack_velocity: Vector2

func _ready():
	centre = get_parent().position
	pass

func _process(delta: float) -> void:
	
	match action:
		ACTION.IDLE:
			idle(delta)
		ACTION.PROTECT:
			protect(delta)
		ACTION.ATTACK:
			attack(delta)
		_:
			return		
			
func change_action(_action) -> void:
	match _action:
		ACTION.IDLE:
			rotate_speed = IDLE_SPEED	
			sphere_position.rotate_speed = IDLE_SPEED			
		ACTION.PROTECT:
			rotate_speed = PROTECT_SPEED
			sphere_position.rotate_speed = PROTECT_SPEED
	action = _action
	
func caclulate_radius_offset() -> float:
	
	if int(radius) == int(radius - radius_total_offset):		
		is_offset_increasing = true

	if int(radius - radius_offset) == int(radius - radius_total_offset):		
		is_offset_increasing = false
		
	return radius_offset_rate * (1 if is_offset_increasing else -1)
	
func idle(_delta: float) -> void:
	angle += rotate_speed * _delta
	
	if int(radius - radius_total_offset)  < int(radius):
		radius_total_offset -= radius_offset_rate
	
	var offset = Vector2(sin(angle), cos(angle)) * (radius - radius_total_offset)
	var pos = centre - offset
	position = pos	
	
func protect(_delta: float) -> void:
	angle += rotate_speed * _delta
	
	radius_total_offset += caclulate_radius_offset()

	var offset = Vector2(sin(angle), cos(angle)) * (radius - radius_total_offset)
	var pos = centre - offset
	position = pos
	
func attack(_delta) -> void:
	global_position += attack_velocity * _delta
	
func calculate_attack_angle() -> void:
	look_at(GameManager.enemy_aim_to.global_position)
	var rotate = Vector2(1, 0).rotated(global_rotation)
	attack_angle = rotate.angle()
	attack_velocity = rotate * ATTACK_SPEED

func _on_TweenAttack_tween_all_completed() -> void:
	action = ACTION.RETREAT
	is_attacking = false
	tween_retreat.interpolate_property(self, "global_position", global_position, GameManager.player.global_position, 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_retreat.start()

func _on_TweenRetreat_tween_all_completed() -> void:
	change_action(ACTION.IDLE)
