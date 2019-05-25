extends Weapon

export var speed : float = 300.0
export var steer_force : float = 20.0

var velocity = Vector2()
var acceleration = Vector2()

signal destroyed 

func _ready() -> void:
	
	DebugManager.debug_remove("missile-collision")
	DebugManager.debug_remove("missile-visibility")
	DebugManager.debug_remove("missile-ttl")
	
func initialize(_weapon_damage : float, _parent : Node, _group_name : String ) -> void:
	
	.initialize(_weapon_damage, _parent, _group_name)
	connect("destroyed", parent, "_on_signal_destroyed")

func _process(delta: float) -> void:
	
	if GameManager.is_enemy_to_attack():
        acceleration += seek()
        velocity += acceleration * delta
        velocity = velocity.clamped(speed)
        global_rotation = velocity.angle()
	global_position += velocity * delta

func shoot(_position, _rotation):
	
	DebugManager.debug("missile", "shoot", DebugManager.weapons_do_debug)
	global_position = _position
	global_rotation = _rotation.angle()
	velocity = _rotation * speed
	$AnimationPlayer.play("fly")
	
func seek() -> Vector2:
	
    var desired = (GameManager.enemy_aim_to.global_position - global_position).normalized() * speed
    var steer = (desired - velocity).normalized() * steer_force
    return steer

func _on_Missile_body_entered(body: PhysicsBody2D) -> void:
	
	DebugManager.debug("missile-collision", "missile collided", DebugManager.weapons_do_debug)
	if body.name == "Ship":
		body.take_damage(weapon_damage)
	destroy()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	
	DebugManager.debug("missile-visibility", "exited screen", DebugManager.weapons_do_debug)
	destroy()

func _on_TimeToLive_timeout() -> void:
	
	DebugManager.debug("missile-ttl", "timeout", DebugManager.weapons_do_debug)
	destroy()

func destroy() -> void:
		
	emit_signal("destroyed")
	call_deferred("free")

