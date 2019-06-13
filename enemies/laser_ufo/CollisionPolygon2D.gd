extends CollisionPolygon2D

const h : float = 1.0
const k : float = 1.0


func _init() -> void:

	var pos = create_semi_circle(80)
	var pos2 = create_semi_circle(40)
	pos2.invert()
	pos.append_array(pos2)		
	polygon = pos	
	
func create_semi_circle(r) -> PoolVector2Array:
	var pos = PoolVector2Array()
	var y
	var min_val = r / 10 / 2
	var max_val = r / 10 	
	
	for x in range(min_val, max_val):
		var xf = x * 10 * -1
		y = circle(r, xf) 	
		pos.append(Vector2(xf,y))

	for x in range(-1 * max_val, max_val + 1):
		var xf = x * 10
		y = circle(r, xf) * -1 	
		pos.append(Vector2(xf,y))	

	for x in range(-1 * max_val + 1, -1 * min_val + 1):
		var xf = x * 10 * -1
		y = circle(r, xf)	
		pos.append(Vector2(xf,y))
	return pos
	
func circle(r, x):
	 return int(sqrt(pow(r,2) - pow(x,2)))
	
