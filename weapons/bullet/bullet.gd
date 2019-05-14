extends Weapon

export var debug : bool = false
export var speed : float = 200.0
export var speed_multiplier : int = 5

onready var bullet_id : int = DebugManager.get_new_bullet_id()
onready var bullet_id_str = "bullet-" + str(bullet_id)

var velocity = Vector2()

func _ready():
	pass 

func _process(delta):
	global_position += velocity * delta
	var text = "position: " + str(global_position) + " rotation:" + str(global_rotation)
	DebugManager.debug(bullet_id_str, text, DebugManager.weapons_do_debug)

func shoot(_position, _rotation):
	global_position = _position
	global_rotation = _rotation.angle()
	velocity = _rotation * speed * speed_multiplier
	var text = "position: " + str(global_position) + " rotation:" + str(global_rotation)
	DebugManager.debug(bullet_id_str, text, DebugManager.weapons_do_debug)

func _on_VisibilityEnabler2D_screen_exited():
	destroy_bullet()

func _on_TimeToLive_timeout():
	destroy_bullet()

func destroy_bullet() -> void:
	DebugManager.debug_remove(bullet_id_str)
	queue_free()

func _on_Bullet_body_entered(body: PhysicsBody2D) -> void:
	DebugManager.debug("bullet-on-boyd-entered",body.name)
	if body.name == "Ship":
		body.take_damage(weapon_damage)
