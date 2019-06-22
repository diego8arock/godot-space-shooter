extends DraggablePanel

var enemy_type
var stats_resource: NpcStartingStats
var level: int

var health: int = 100
onready var health_value = $PanelContainer/Container/StatsContainer/HealthContainer/HealthValue
#stats
var speed: float
var attack: float
var defense: float
var xp: float

func _ready():
	$PanelContainer/Container/Type.text = enemy_type
	$PanelContainer.connect("mouse_entered", self, "_on_PanelContainer_mouse_entered")
	$PanelContainer.connect("mouse_exited", self, "_on_PanelContainer_mouse_exited")
	pass

func _on_Button_pressed() -> void:
	pass # Replace with function body.

func _on_HealthButton_pressed() -> void:
	health = 100
	health_value.text = str(health)
