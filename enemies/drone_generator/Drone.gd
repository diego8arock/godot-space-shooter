extends NPC

onready var muzzle = $Sprite/Muzzle

var exit_point : Position2D

func _ready() -> void:
	._ready()
	states_map = {
		"fly" : $States/Fly,
		"shoot" : $States/Shoot
	}
	states_stack.push_back($States/Fly)
	current_state = states_stack[0]
	_change_state("fly")

func _on_Drone_area_entered(area: Area2D) -> void:
	process_area_entered(area)
