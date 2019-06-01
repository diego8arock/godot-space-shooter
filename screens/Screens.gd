extends Node

signal start_game()
signal continue_game(_skip)

var current_screen = null

func _ready() -> void:
	register_buttons()
	change_screen($TitleScreen)
	
func register_buttons() -> void:
	var buttons = get_tree().get_nodes_in_group("menu_buttons")
	for b in buttons:
		b.connect("pressed", self, "_on_button_pressed", [b])
	pass
		
func _on_button_pressed(_button) -> void:
	_button.release_focus() # Prevents button to be callend when pressed space bar
	match _button.name:
		"Home":
			change_screen($TitleScreen)
		"Play":
			change_screen(null)
			yield(get_tree().create_timer(0.5), "timeout")			
			emit_signal("start_game")
		"Options":
			change_screen($OptionsScreen)
		"Continue":
			change_screen(null)
			emit_signal("continue_game", false)
		"Skip":
			change_screen(null)
			emit_signal("continue_game", true)
		"Exit":
			change_screen($TitleScreen)

func change_screen(_new_screen) -> void:
	if current_screen:
		current_screen.disappear()
		yield(current_screen.tween, "tween_completed")
	current_screen = _new_screen
	if _new_screen:
		current_screen.appear()
		yield(current_screen.tween, "tween_completed")