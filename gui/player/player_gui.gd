extends CanvasLayer

func _ready() -> void:
	GameManager.player_gui = self

func update_healthbar(_value) -> void:
    $Margin/Container/HeatlhContainer/HealthBar.value = _value
	
func update_powerbar(_value) -> void:
    $Margin/Container/PowerContainer/PowerBar.value = _value
