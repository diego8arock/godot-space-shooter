extends State

func enter(_host) -> void:
	.enter(_host)
	
func exit(_host) -> void:
	.exit(_host)
	
func update(_host, _delta) -> String:
	return ConstManager.EMPTY_STRING
