extends Node2D

onready var label = $Label

var velocity = Vector2()
var speed : float = 50.0


func set_number(_number: String) -> void:
	label.text = _number
	
func set_start_position(_position: Vector2, _rotation: Vector2) -> void:
	global_position = _position
	global_rotation = _rotation.angle()
	velocity = _rotation * speed 
	
func show_number() -> void:
	$Tween.interpolate_property(label, "modulate", Color(1,0,0,1), Color(1,0,0,0), 1.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()	
	
func _process(delta: float) -> void:
	global_rotation = 0
	global_position += velocity * delta

func _on_Tween_tween_all_completed() -> void:
	queue_free()
