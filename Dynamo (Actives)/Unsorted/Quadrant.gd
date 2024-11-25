extends Polygon2D

var screenArea: Vector2
var SIDE: Vector2
var DEPTH : Vector2
var quadrant : Vector2

func _ready():
	screenArea = get_viewport().get_visible_rect().size
	SIDE = Vector2(screenArea.x/4,screenArea.y)
	DEPTH = Vector2(screenArea.x/2,screenArea.y/2)
	quadrant = Vector2(screenArea.x - (SIDE.x/2), DEPTH.y)

func _draw():
	# RIGHT_QUADRANT
	#self.offset = Vector2(screenArea.x - (SIDE.x/2), DEPTH.y)
	
	self.draw_rect(Rect2(Vector2(screenArea.x-SIDE.x,0),SIDE),Color.GRAY)

	## LEFT_QUADRANT
	#offset = Vector2(SIDE.x/2,DEPTH.y)
#
	## TOP_QUADRANT
	#offset = Vector2(DEPTH.x,DEPTH.y/2)
#
	## BOTTOM_QUADRANT
	#offset = Vector2(DEPTH.x,SIDE.y - (DEPTH.y/4))
