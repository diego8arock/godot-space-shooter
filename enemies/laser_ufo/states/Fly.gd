extends State

func enter(_host: Node2D) -> void:
	.enter(_host)

func exit(_host: Node2D) -> void:
	.exit(_host)

func update(_host: Node2D, _delta: float) -> String:
	return ConstManager.EMPTY_STRING