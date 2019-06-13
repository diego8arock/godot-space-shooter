extends State

var random_positions = []
var rotation_position = []

onready var vp_x = get_viewport().size.x
onready var vp_y = get_viewport().size.y
var offset = 100
var aim_at = Vector2()

func _ready() -> void:
	
	random_positions.push_back(Vector2(vp_x / 2, -offset)) #top
	random_positions.push_back(Vector2(vp_x / 2, vp_y + offset)) #bottom
	random_positions.push_back(Vector2(-offset , vp_y / 2)) # left
	random_positions.push_back(Vector2(vp_x + offset , vp_y / 2)) # right
	
	rotation_position.push_back(90)
	rotation_position.push_back(270)
	rotation_position.push_back(0)
	rotation_position.push_back(180)

func enter(_host: Node2D) -> void:
	randomize()
	var index = randi() % random_positions.size()
	_host.global_position = random_positions[index]
	_host.global_rotation = deg2rad(rotation_position[index])
	execute_state = false

func exit(_host: Node2D) -> void:
	execute_state = true
		
func update(_host: Node2D, _delta: float) -> String:
	
	if not execute_state:
		return "aim"
	
	return ConstManager.EMPTY_STRING
	