extends KinematicBody2D

var speed: float = 0.0
var speed_rate: float = 1.0
var velocity: Vector2 = Vector2(1,0)
var velocity_rotation: float = 0.0
var velocity_rotation_speed: float = 3.0

const MAX_SPEED: float = 5.0
const MAX_SPEED_REVERSE: float = -5.0

var is_forward: bool = true
var is_reverse: bool = true

var velocity_debug: Label
var angle_debug: Label
var speed_debug: Label
var font: Font = preload("res://assets/gui/player/health_dynamicfont.tres")

export (NodePath) var bullet_container_path
var bullet_container 

export (NodePath) var crosshair_path
var crosshair

onready var turret = $Sprite/ProtoPlayerTurret

func _ready():
	
	crosshair = get_node(crosshair_path)
	bullet_container = get_node(bullet_container_path)
	turret.parent = self
	
	velocity_debug = Label.new()
	velocity_debug.add_font_override("font", font)
	$Debug.add_child(velocity_debug)
	
	angle_debug = Label.new()
	angle_debug.add_font_override("font", font)
	$Debug.add_child(angle_debug)
	
	speed_debug = Label.new()
	speed_debug.add_font_override("font", font)
	$Debug.add_child(speed_debug)	


func _process(delta: float) -> void:
	
	if Input.is_action_pressed("ui_up"):
		foward(delta)
		
	if Input.is_action_pressed("ui_down"):
		reverse(delta)
	
	if Input.is_action_pressed("ui_right"):
		turning_right(delta)	
		
	if Input.is_action_pressed("ui_left"):
		turning_left(delta)
		
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		ProtoAutoload.slow_down_time()
	else:
		ProtoAutoload.normal_time()

func _physics_process(delta: float) -> void:	
	
	var move: Vector2 = velocity.normalized().rotated(velocity_rotation) * (speed / ProtoAutoload.time_flow)
	velocity_debug.text = str(move)
	angle_debug.text = str(rad2deg(move.angle()))
	speed_debug.text = str(speed)
	$Sprite.global_rotation = velocity_rotation + deg2rad(90)
	move_and_collide(move)
	
func foward(_delta: float) -> void:
	
	speed += speed_rate * _delta
	speed = clamp(speed, MAX_SPEED_REVERSE, MAX_SPEED)
	is_forward = true
	is_reverse = false
	
func reverse(_delta: float) -> void:
	
	speed -= speed_rate * _delta
	speed = clamp(speed, MAX_SPEED_REVERSE, MAX_SPEED)
	is_forward = false
	is_reverse = true
	
func turning_right(_delta: float) -> void:
	
	if is_forward:
		velocity_rotation += (velocity_rotation_speed / ProtoAutoload.time_flow) * _delta
	if is_reverse:
		velocity_rotation -= (velocity_rotation_speed / ProtoAutoload.time_flow) * _delta				
	
func turning_left(_delta: float) -> void:
	
	if is_forward:
		velocity_rotation -= (velocity_rotation_speed / ProtoAutoload.time_flow) * _delta
	if is_reverse:	
		velocity_rotation += (velocity_rotation_speed / ProtoAutoload.time_flow) * _delta
	