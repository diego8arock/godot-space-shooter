extends Area2D

onready var sphere_position = preload("res://enemies/protector/SpherePosition.tscn")
onready var sphere = preload("res://enemies/protector/Sphere.tscn")
onready var spheres_container = $SpheresContainer

const SPHERE_RADIUS : float = 100.0

#TODELETE
var level = 25

func _ready():
	#._ready()
	create_spheres()

func create_spheres() -> void:
	var total_spheres
	if level < 3:
		total_spheres = 1
	elif level >= 3 and level < 9:
		total_spheres = 2
	elif level >= 8 and level < 20:
		total_spheres = 3
	else:
		total_spheres = 4
	
	var divison = 360 / total_spheres
	var angle = 0
	for c in range(0, total_spheres):
		var pos = Vector2(SPHERE_RADIUS, 0).rotated(deg2rad(angle))		
		add_sphere(pos, angle)
		angle += divison	
	$Idle.start()	
	
func add_sphere(_pos: Vector2, _angle: float) -> void:
	var new_sphere = sphere.instance()
	spheres_container.add_child(new_sphere)
	new_sphere.angle = deg2rad(_angle)
	new_sphere.radius = SPHERE_RADIUS
	new_sphere.position = _pos
	new_sphere.sphere_position = add_sphere_position(_pos, _angle)
	
func add_sphere_position(_pos: Vector2, _angle:float) -> Node2D:
	var new_sphere = sphere_position.instance()
	spheres_container.add_child(new_sphere)
	new_sphere.angle = deg2rad(_angle)
	new_sphere.radius = SPHERE_RADIUS
	new_sphere.position = _pos
	return new_sphere

func set_sphere_action(action) -> void:
	for c in spheres_container.get_children():
		if c.has_method("change_action"):
			c.change_action(action)

enum ACTION { IDLE, PROTECT, ATTACK }
func _on_Idle_timeout() -> void:
	set_sphere_action(ACTION.IDLE)
	#$Protect.start()
	$Attack.start()

func _on_Protect_timeout() -> void:
	set_sphere_action(ACTION.PROTECT)
	$Idle.start()

func _on_Attack_timeout() -> void:
	var s = spheres_container.get_children()[0]
	s.calculate_attack_angle()
	s.change_action(ACTION.ATTACK)
