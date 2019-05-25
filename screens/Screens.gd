extends Node

signal start_game

var current_screen = null

func _ready() -> void:
	register_buttons()
	change_screen($TitleScreen)
	
func register_buttons() -> void:
	var buttons = get_tree().get_nodes_in_group("menu_buttons")
	for b in buttons:
		b.connect("pressed", self, "_on_button_pressed", [b.name])
	pass
		
func _on_button_pressed(name) -> void:
	match name:
		"Home":
			pass
		"Play":
			current_screen.disable_buttons()
			change_screen(null)
			yield(get_tree().create_timer(0.5), "timeout")			
			emit_signal("start_game")
		"Settings":
			pass

func change_screen(_new_screen) -> void:
	if current_screen:
		current_screen.disappear()
		yield(current_screen.tween, "tween_completed")
	current_screen = _new_screen
	if _new_screen:
		current_screen.appear()
		yield(current_screen.tween, "tween_completed")