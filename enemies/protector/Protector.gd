extends NPC

onready var bullet = preload("res://weapons/bullet/mid_bullet/MidBulletEnemy.tscn")
onready var sphere_position = preload("res://enemies/protector/SpherePosition.tscn")
onready var sphere = preload("res://enemies/protector/Sphere.tscn")
onready var spheres_container = $SpheresContainer
onready var shield = $Shield/CollisionShape2D
onready var left_muzzle = $Pivot/Muzzles/Left
onready var right_muzzle = $Pivot/Muzzles/Right
onready var shoot_timer = $ShootTimer
onready var pivot = $Pivot

var resizing_shield: bool = false

const SPHERE_RADIUS : float = 100.0
enum ACTION { IDLE, PROTECT, ATTACK }

var aim_speed: float = 5.0

var seek_speed: float = 300.0
var seek_steer_force : float = 0.5
var velocity = Vector2()
var acceleration = Vector2()
var is_seeking: bool = false

var chase_speed: float = 100.0
var chase_steer_force: float = 2.3

var attack_speed: float = 50.0
var attack_steer_force: float = 6.0
var is_attacking: bool = false

func _ready():
    ._ready()
    level = 25
    states_map = {
        "idle" : $States/Idle,
        "protect" : $States/Protect,
        "attack" : $States/Attack
    }
    create_spheres()
    velocity = Vector2(1, 0).rotated(global_rotation) * chase_speed	
    states_stack.push_back($States/Idle)
    current_state = states_stack[0]
    _change_state("idle")
    
func _process(delta: float) -> void:
        
    spheres_container.global_rotation = 0
    ._process(delta)

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

func _on_Shield_area_entered(area: Area2D) -> void:
    if area.is_in_group(WeaponManager.GROUP_WEAPON_PLAYER):
        GameManager.create_bullet_on_shield_explosion(area.global_position)
        area.call_deferred("free")

func _on_ShootTimer_timeout() -> void:
    shoot(left_muzzle)
    shoot(right_muzzle)
    shoot_timer.start()

func shoot(_muzzle) -> void:
    var new_bullet : BaseBullet = bullet.instance()
    new_bullet.initialize( 20, self,  WeaponManager.GROUP_WEAPON_ENEMY)
    WeaponManager.add_weapon(new_bullet, scale.x, scale.y)
    var direction = Vector2(1, 0).rotated(_muzzle.global_rotation)
    new_bullet.shoot(_muzzle.global_position, direction)
    
func stop_shooting() -> void:
    shoot_timer.stop()
    
func start_shooting() -> void:
    shoot_timer.start()

func steer(_delta: float, speed: float, force: float) -> void:
    if GameManager.is_enemy_to_attack():
        var desired = (GameManager.enemy_aim_to.global_position - global_position).normalized() * speed
        var steer = (desired - velocity).normalized() / force
        velocity += steer
        global_rotation = velocity.angle()
    global_position += velocity * _delta

func _on_Protector_area_entered(area: Area2D) -> void:
    process_area_entered(area)
