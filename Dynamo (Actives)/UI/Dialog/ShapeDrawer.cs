using Godot;

public partial class ShapeDrawer : Node2D
{
	//private SceneTree tree;
	//private Window pane;
	//private Viewport screen;
	//private Node scene;
	private Sprite2D dialog;
	private Label scryb;
	private Polygon2D frame;
	private void OnSizeChanged()
	{
		Vector2 resized = App.area.GetVisibleRect().Size;
		bool increasing = true;
		if (resized.X < App.size.X || resized.Y < App.size.Y) increasing = false;
		
		if (App.size.X == resized.X || App.size.Y == resized.Y)
		{
			App.size = resized;
			dialog.init(increasing);
			scryb.init();
			frame.init();
			return;
		}
		App.size = resized;
		dialog.init(increasing);
		scryb.init();
		frame.init();
	}
	public override void _Ready()
	{
		//tree = this.GetTree();
		//pane = tree.Root;
		App.pane.SizeChanged += OnSizeChanged;
		//scene = tree.CurrentScene;
		//screen = scene.GetViewport();
		dialog = this.GetNode<Sprite2D>("Dialog");
		scryb = this.GetNode<Label>("Container/Message");
		frame = this.GetNode<Polygon2D>("Portrait");
	}
}
