extends RigidBody2D

onready var bomb = $Sprite
onready var ligth = $Sprite/Light
onready var animation = $AnimationPlayer
onready var timer = $ExplodeTimer
onready var invincible = $InivincibleTimer

var radius : float = 5.0
var green =  Color(0.5,1,0.1,1)
var red =  Color(1,0.1,0.1,1)
var process_damage : bool = false
var last_position : Vector2
var is_body_inside_aoe : bool = false
var body_in_aoe : PhysicsBody2D
var damage = 10

func _ready():	
	ligth.modulate = green
	animation.play("countdown") 
	#eject(Vector2(1,1), 50.0)
	
func _physics_process(delta: float) -> void:
	
	if process_damage:
		global_position = last_position
		execute_damage()
	
func eject(_dir: Vector2, _force: float) -> void:
	apply_impulse(Vector2(), _dir * _force)

func execute_damage() -> void:
	if is_body_inside_aoe:
		body_in_aoe.take_damage(damage)
		
func explode() -> void:
	bomb.hide()
	animation.play("shockwave")
	GameManager.create_bomb_explosion(global_position)
	call_deferred("mode", RigidBody2D.MODE_STATIC)
	last_position = global_position
	GameManager.create_bullet_explosion(global_position)
	process_damage = true

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "countdown":
		ligth.modulate = red
		timer.start()
	if anim_name == "shockwave":
		call_deferred("free")

func _on_ExplodeTimer_timeout() -> void:
	explode()

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	DebugManager.debug(name,body.name,DebugManager.weapons_do_debug)
	if body.name == ConstManager.BODY_SHIP_NAME:
		is_body_inside_aoe = true
		body_in_aoe = body
		
		if not process_damage:
			timer.stop()
			explode()		

func _on_Area2D_body_exited(body: PhysicsBody2D) -> void:
	is_body_inside_aoe = false

func _on_Area2D_area_entered(area: Area2D) -> void:
	if invincible.time_left == 0.0 and area.is_in_group(WeaponManager.GROUP_WEAPON_PLAYER):
		explode()