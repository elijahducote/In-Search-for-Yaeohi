using Godot;

public partial class App : Node
{
	public static SceneTree graf;
	public static Window pane;
	public static Node root;
	public static Viewport area;
	public static Vector2 span;
	public static Vector2 size;
	
	public override void _Ready()
	{
		graf = this.GetTree();
		pane = graf.Root;
		root = graf.CurrentScene;
		area = root.GetViewport();
		span = area.GetVisibleRect().Size;
		size = span;
	}
}
