extends Area2D

func play() -> void:
	$Sprite.show()
	$AnimationPlayer.play("shockwave")
	
func play_backwards() -> void:
	$Sprite.show()
	$AnimationPlayer.play_backwards("shockwave")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "shockwave":
		$Sprite.hide()
