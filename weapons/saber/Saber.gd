extends Weapon

signal attack_ended()
	
func attack() -> void:
	$AnimationPlayer.play("attack")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("attack_ended")

func _on_Saber_body_entered(body: PhysicsBody2D) -> void:
	DebugManager.debug(name,body.name,DebugManager.weapons_do_debug)
	if body.name == ConstManager.BODY_SHIP_NAME:
		body.take_damage(weapon_damage)
