extends Node2D

func start() -> void:
	$Particles2D.emitting = true
	
func stop() -> void:
	$Particles2D.emitting = false