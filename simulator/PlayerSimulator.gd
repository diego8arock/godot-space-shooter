extends DraggablePanel

func _ready():
	$PanelContainer.connect("mouse_entered", self, "_on_PanelContainer_mouse_entered")
	$PanelContainer.connect("mouse_exited", self, "_on_PanelContainer_mouse_exited")
