extends Sprite

onready var bullet : PackedScene = preload("res://prototypes/player-movement/ProtoBullet.tscn")
var parent
var bullet_offset = 5

func _process(delta: float) -> void:
		
	look_at(parent.crosshair.global_position)	
		
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if $ShootTimer.time_left == 0:
			$ShootTimer.start()
			
	if Input.is_action_just_released("left_button"):
		$ShootTimer.stop()	
	
	pass

func shoot() -> void:
	var new_bullet = bullet.instance()
	var direction = Vector2(1, 0).rotated($Pivot/Muzzle.global_rotation + deg2rad(90))
	new_bullet.shoot($Pivot/Muzzle.global_position, direction)	
	new_bullet.global_scale = global_scale
	parent.bullet_container.add_child(new_bullet)

func _on_ShootTimer_timeout() -> void:
	shoot()
