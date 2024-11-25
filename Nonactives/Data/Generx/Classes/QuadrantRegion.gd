class_name QuadrantRegion
extends Resource

const RIGHT = Vector3.RIGHT
const LEFT = Vector3.LEFT
const AHEAD = Vector3.FORWARD
const BACK = Vector3.BACK
var picked : Vector3

var index : int = 0

@export_enum("RIGHT","LEFT","AHEAD","BACK") var direction: int :
	set(value):
		index = value
		match(index):
			0:
				picked = RIGHT
			1:
				picked = LEFT
			2:
				picked = AHEAD
			3:
				picked = BACK

func get_option() -> Vector3:
	return picked
