extends Control

var screen : Viewport
var quadrant : Array[Node]
var dendros : SceneTree
var scene : Node
var dimensions : Vector2

func compose(screenArea : Vector2) -> void:
	if (not screenArea.y == dimensions.y):
		if (not screenArea.x == dimensions.x):
			var SIDE : Vector2 = Vector2(screenArea.x/4,screenArea.y)
			var DEPTH : Vector2 = Vector2(screenArea.x/2,screenArea.y/2)
			SIDE = round(SIDE)
			DEPTH = round(DEPTH)
			quadrant[0].position = Vector2(screenArea.x-SIDE.x,0)
			quadrant[0].size = SIDE
			quadrant[1].position = Vector2(0,0)
			quadrant[1].size = SIDE
			quadrant[2].position = Vector2(SIDE.x,0)
			quadrant[2].size = DEPTH
			quadrant[3].position = Vector2(SIDE.x,DEPTH.y)
			quadrant[3].size = DEPTH
			dimensions = screenArea
	
func _ready() -> void:
	dendros = self.get_tree()
	scene = dendros.current_scene
	screen = scene.get_viewport()
	quadrant = dendros.get_nodes_in_group("Trellis")
	screen.connect("size_changed",_on_size_changed)
	compose(screen.get_visible_rect().size)

func _on_size_changed() -> void:
	compose(screen.get_visible_rect().size)
