extends Weapon

onready var line = $Line2D
onready var collision = $CollisionShape2D

var collision_shape : SegmentShape2D
var laser_activated : bool = false
var endpoint = Vector2(10,0)
var growth_speed = 5
var max_range

func _ready():
	collision_shape = collision.shape
	var size_x = get_viewport().size.x
	var size_y = get_viewport().size.y
	max_range = size_x if size_x > size_y else size_y
		
func _process(delta: float) -> void:
	
	if laser_activated:
		grow_laser()
		
	if not laser_activated:
		shrink_laser()
	
func activate_laser() -> void:
	laser_activated = true
	
func deactivate_laser() -> void:
	laser_activated = false
		
func grow_laser() -> void:
	if line.points[1].x <= max_range:
		line.points[1] += Vector2(growth_speed, 0)
		collision_shape.b = line.points[1]
		
func shrink_laser() -> void:
	
	if line.points[1].x >= 0:
		line.points[1] -= Vector2(growth_speed, 0)
		collision_shape.b = line.points[1]	

func _on_Laser_body_entered(body: PhysicsBody2D) -> void:
	DebugManager.debug(name,body.name,DebugManager.weapons_do_debug)
	if body.name == "Ship":
		body.take_damage(weapon_damage)

