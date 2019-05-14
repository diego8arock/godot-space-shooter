extends VBoxContainer

onready var parent = get_parent()

func update_healthbar(_value) -> void:
	$HealthBar.value = _value
	

