extends Node

var bullet_time_divisor: float = 3.0
var normal_time_divisor: float = 1.0
var time_flow: float

func _ready():
	time_flow = normal_time_divisor

func slow_down_time() -> void:
	time_flow = bullet_time_divisor
	
func normal_time() -> void:
	time_flow = normal_time_divisor