extends Weapon


var rotate_speed = 3

onready var tween = $Tween
onready var shield = $Sprite
onready var collision = $CollisionPolygon2D

signal shield_disolved()

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	
	rotation += rotate_speed * delta
	
func disolve_shield() -> void:
	tween.interpolate_property(shield, "modulate", Color(1,1,1,1), Color(1,1,1,0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	collision.disabled = true
	emit_signal("shield_disolved")

func _on_Timer_timeout() -> void:
	#disolve_shield()
	pass

func _on_LaserUfoShield_area_entered(area: Area2D) -> void:
	if area.is_in_group(WeaponManager.GROUP_WEAPON_PLAYER):
		randomize()
		var rad = deg2rad(135 * (1 if randi() % 2 == 0 else -1))
		area.global_rotation += rad
		area.velocity = area.velocity.rotated(rad)
