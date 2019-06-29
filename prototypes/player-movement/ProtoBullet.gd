extends Area2D

export var speed : float = 200.0
export var speed_multiplier : int = 5

onready var bullet_id : int = DebugManager.get_new_bullet_id()
onready var bullet_id_str = "bullet-" + str(bullet_id)

var velocity = Vector2()

func _process(delta):
	global_position += velocity * delta
	var debug_text = "position: " + str(global_position) + " rotation:" + str(global_rotation)
	DebugManager.debug(bullet_id_str, debug_text, DebugManager.weapons_do_debug)

func shoot(_position: Vector2, _rotation: Vector2):
	global_position = _position
	global_rotation = _rotation.angle()
	velocity = _rotation * (speed / ProtoAutoload.time_flow) * speed_multiplier

func _on_VisibilityEnabler2D_screen_exited():
	destroy_bullet()

func _on_TimeToLive_timeout():
	destroy_bullet()

func destroy_bullet() -> void:
	call_deferred("free")

