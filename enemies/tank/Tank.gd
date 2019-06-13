extends NPC

onready var launcher = $States/EjectBomb/BombLauncher
onready var bomb = preload("res://weapons/bomb/Bomb.tscn")

var rotate_speed = 0.1
var radius = 270
var centre
var angle = 0 

func _ready() -> void:
	._ready()
	states_map = {
		"idle" : $States/Idle,
		"eject_bomb" : $States/EjectBomb
	}
	centre = global_position
	states_stack.push_back($States/Idle)
	current_state = states_stack[0]
	_change_state("idle")
	
func _process(delta: float) -> void:
	
	aim_at_player(delta)
	rotate_in_circles(delta)
		
	._process(delta)
			
func aim_at_player(_delta : float) -> void:	
	
	if  GameManager.is_enemy_to_attack():
		var target_dir = (GameManager.enemy_aim_to.global_position - global_position).normalized()
		var current_dir = Vector2(1, 0).rotated(launcher.global_rotation)
		launcher.global_rotation = current_dir.linear_interpolate(target_dir, 5 * _delta).angle()
		
func rotate_in_circles(_delta: float) -> void:
		
	angle += rotate_speed * _delta

	var offset = Vector2(sin(angle), cos(angle)) * radius
	var pos = centre - offset
	global_position = pos
	$Sprite.look_at(centre)

func _on_Tank_area_entered(area: Area2D) -> void:
		process_area_entered(area)
