extends NPC

var rotate_speed = 1

onready var laser_container = $LaserContainer
onready var shield = $Sprite/LaserUfoShield

func _ready() -> void:
	._ready()
	states_map = {
		"fly" : $States/Fly,
		"attack" : $States/Attack
	}
	
	for c in laser_container.get_children():
		(c as Weapon).initialize(WeaponManager.DAMAGE_INSTA_KILL, self, WeaponManager.GROUP_WEAPON_ENEMY)
	
	states_stack.push_back($States/Fly)
	current_state = states_stack[0]
	_change_state("fly")
	
func _process(delta: float) -> void:
		
	$Sprite.rotation += rotate_speed * delta	
		
	._process(delta)
	
func _on_LaserUfo_area_entered(area: Area2D) -> void:
	process_area_entered(area)
