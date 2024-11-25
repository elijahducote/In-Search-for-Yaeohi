extends ColorRect

@export var resource : QuadrantRegion
var controller : RigidBody3D

func _ready():
	var graph : SceneTree = self.get_tree()
	var level : Node = graph.current_scene
	controller = level.get_node("Player")
	self.connect("mouse_entered",_on_mouse_entered)
		
func _on_mouse_entered():
	controller.dir = self.resource.get_option()
