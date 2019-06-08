extends Node2D

func _ready():
	pass

func _unhandled_key_input(event):	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()