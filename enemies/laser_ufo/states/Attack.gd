extends State

var lasers : Node2D
var rotate : bool = false
var rotate_speed = 1

func enter(_host: Node2D) -> void:
	.enter(_host)
	_host.shield.disolve_shield()
	lasers = _host.laser_container

func exit(_host: Node2D) -> void:
	.exit(_host)

func update(_host: Node2D, _delta: float) -> String:
	
	if rotate:
		lasers.rotation += rotate_speed * _delta
	
	return ConstManager.EMPTY_STRING

func _on_LaserUfoShield_shield_disolved() -> void:
	for l in lasers.get_children():
		l.activate_laser()
	rotate = true
