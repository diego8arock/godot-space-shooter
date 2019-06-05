extends Node2D

onready var particles = $CPUParticles2D

func _ready() -> void:
	particles.emitting = true

func set_position(_pos : Vector2) -> void:
	global_position = _pos

func _on_LifeTime_timeout() -> void:
	call_deferred("free")
