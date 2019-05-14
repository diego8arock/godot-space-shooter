extends Weapon

export var speed : float = 200.0
export var speed_multiplier : int = 5

onready var bullet_id : int = DebugManager.get_new_bullet_id()
onready var bullet_id_str = "bullet-" + str(bullet_id)

var velocity = Vector2()

func _ready():
	pass

func _process(delta):
	global_position += velocity * delta
	DebugManager.debug(bullet_id_str, "position: " + str(global_position) + " rotation:" + str(global_rotation), DebugManager.weapons_do_debug)
	pass

func shoot(_position, _rotation):
	global_position = _position
	global_rotation = _rotation.angle()
	DebugManager.debug(bullet_id_str, "position: " + str(global_position) + " rotation:" + str(global_rotation), DebugManager.weapons_do_debug)
	velocity = _rotation * speed * speed_multiplier

func _on_VisibilityEnabler2D_screen_exited():
	destroy_bullet()

func _on_TimeToLive_timeout():
	destroy_bullet()

func destroy_bullet() -> void:
	DebugManager.debug_remove(bullet_id_str)
	queue_free()