extends RigidBody2D

onready var parts = ["res://assets/damage/damage1.png","res://assets/damage/damage2.png","res://assets/damage/damage3.png","res://assets/damage/damage4.png","res://assets/damage/damage5.png","res://assets/damage/damage6.png","res://assets/damage/damage7.png","res://assets/damage/damage8.png","res://assets/damage/damage9.png"]

func _init() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
	
func _ready() -> void:
	set_parts()
	
func create_damage(_pos : Vector2, _scale) -> void:
	global_position = _pos
	$Sprite.scale = $Sprite.scale * _scale
	set_position(_pos)
	randomize()
	add_torque (randi() % 180)
	apply_central_impulse(Vector2(rand_range(0,1),rand_range(0,1)) * 25)

func set_parts() -> void:
	randomize()
	var index = rand_range(0, parts.size() - 1)
	var img = load(parts[index])
	$Sprite.texture = img

func _on_TimerToLive_timeout() -> void:
	call_deferred("free")
