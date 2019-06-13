extends State

onready var saber
onready var tween : Tween = $Tween
var line : Line2D
var can_attack : bool = true
const TWEEN_BASE_SPEED : float = 50.0
const DISTANCE_THRESHOLD : float = 150.0

func enter(_host: Node2D) -> void:
	saber = _host.get_node("Saber")
	var final  = _host.get_node("Sprite").get_node("Line2D").get_node("Position2D")
	tween.interpolate_property(_host, "global_position", _host.global_position, final.global_position, TWEEN_BASE_SPEED / _host.stats.speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()	

func exit(_host: Node2D) -> void:
	execute_state = true

func update(_host: Node2D, _delta: float) -> String:
	
	if distance_to_player(_host) <= DISTANCE_THRESHOLD and can_attack:
		attack(_host)
	
	if not execute_state:
		return "adjust"
	
	return ConstManager.EMPTY_STRING	

func distance_to_player(_host: Node2D) -> float:
	var diff_x = pow(GameManager.enemy_aim_to.global_position.x - _host.global_position.x, 2)
	var diff_y = pow(GameManager.enemy_aim_to.global_position.y - _host.global_position.y, 2)
	return sqrt(diff_x + diff_y)
	
func attack(_host: Node2D) -> void:
	saber.show()
	saber.attack()
	can_attack = false	

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	execute_state = false

func _on_Saber_attack_ended() -> void:
	saber.hide()
	can_attack = true
