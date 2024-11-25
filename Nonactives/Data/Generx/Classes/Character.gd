class_name Character
extends Resource

@export_group("Dimensions")
@export_range(1,4096) var length : float :
	get:
		return length
	set (value):
		length = value
