extends State

onready var launcher = $BombLauncher
onready var bomb = preload("res://weapons/bomb/Bomb.tscn")

func enter(_host: Node2D) -> void:
	 eject_bomb(_host)

func exit(_host: Node2D) -> void:
	execute_state = true

func update(_host: Node2D, _delta: float) -> String:
	
	if not execute_state:
		return "idle"
	
	return ConstManager.EMPTY_STRING	
	
func eject_bomb(_host: Node2D) -> void:
	var new_bomb = bomb.instance()
	WeaponManager.add_weapon(new_bomb)
	new_bomb.global_position = _host.global_position
	var current_dir = Vector2(1, 0).rotated(launcher.global_rotation)
	new_bomb.eject(current_dir, 100)
	execute_state = false
	
