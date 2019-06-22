extends VBoxContainer

func update_healthbar(_value) -> void:
	$HealthBar.value = _value	

func show_number(_number: int) -> void:
	var position = $Direction.global_position
	var rotation = Vector2(1,0).rotated($Direction.global_rotation)
	GameManager.create_number(position, rotation, str(_number))