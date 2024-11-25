using Godot;
using System;
// ROOT
public partial class ControlScheme : Node
{
	private const string _Nput = "SPACE ETAOINSRHLDCUMPFGYWBVKXJQZ ENTER BACKSPACE ,. SHIFT TAB CAPSLOCK CTRL ALT  OPTION ESCAPE UP DOWN LEFT RIGHT 3210589647!@#$%^&*()-~_=+[]{}\\|;:\"'`<>/? ";
	private SceneTree tree;
	private Node scene;
	private Viewport screen;
	private Window pane;
	private Vector2 SIDE;
	private Vector2 DEPTH;
	private Vector2 space;
	private float dpi;
	public override void _Ready()
	{
		tree = this.GetTree();
		pane = tree.Root;
		scene = tree.CurrentScene;
		screen = scene.GetViewport();
		dpi = DisplayServer.ScreenGetDpi() * DisplayServer.ScreenGetScale();
		space = screen.GetVisibleRect().Size;
		SIDE = new Vector2(space.X/4,space.Y);
		DEPTH = new Vector2(space.X/2,space.Y/2);
		Input.MouseMode = Input.MouseModeEnum.Confined;
		pane.FocusEntered += OnWindowFocused;
		pane.FocusExited += OnWindowExited;
	}
	private static void OnWindowFocused()
	{
		GD.Print("focused");
	}
	private static void OnWindowExited()
	{
		GD.Print("not focused");
		Input.MouseMode = Input.MouseModeEnum.Visible;
	}
	public override void _Input(InputEvent @event)
	{
		if (@event is InputEventMouseMotion eventMouseMotion)
		{
			 // Get the absolute position of the mouse
			Vector2 absolutePosition = eventMouseMotion.Position;
			GD.Print("Mouse Absolute Position: ", absolutePosition);
			if (absolutePosition.Y == 0) Input.WarpMouse(new Vector2(DEPTH.X,SIDE.Y - (DEPTH.Y/2)));
			//else if (absolutePosition.Y == space.Y - 1) Input.WarpMouse(new Vector2(DEPTH.X,DEPTH.Y/2));
			//if (absolutePosition.X == 0) Input.WarpMouse(new Vector2(space.X - (SIDE.X/2), DEPTH.Y));
			//else if (absolutePosition.X == space.X - 1) Input.WarpMouse(new Vector2(SIDE.X/2, DEPTH.Y));
			// Get the relative movement of the mouse
			//Vector2 relativeMovement = eventMouseMotion.Relative;
			//GD.Print("Mouse Relative Movement: ", relativeMovement);
			// Get the velocity of the mouse
			//Vector2 velocity = eventMouseMotion.Velocity;
			//GD.Print("Mouse Velocity: ", velocity);
		}
		if (@event is InputEventKey keyEvent)
		{
			if (keyEvent.Pressed)
			{
				int length = _Nput.Length,
				ItR8 = length,
				match = 0,
				key = 0,
				cur,
				prev,
				code;
				ReadOnlySpan<char> stroke;
				for (prev = 0;ItR8 > 0;--ItR8) {
					cur = length - ItR8;
					code = _Nput[cur];
					if (code == 32)
					{
						stroke = _Nput.AsSpan(prev,cur-prev);
						key = (int) OS.FindKeycodeFromString(stroke.ToString());
						//GD.Print(stroke.ToString() + "\n");
						// code that does something
						//if (mark !== 0) stroke 
						prev = cur;
						++prev;
						if (key == 0) continue;
						else if ((int) keyEvent.Keycode == key) break;
						if (match != 0) {
							key = match;
							break;
						}
						if (_Nput[cur + 1] == 32)
						{
							--ItR8;
							++prev;
						}
					}
					else if ((int) keyEvent.Keycode == code) match = code;
				}
				GD.Print(key);
			}
			screen.SetInputAsHandled();
		}
	}
}
