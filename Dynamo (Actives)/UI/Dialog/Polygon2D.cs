using Godot;
using System;

public partial class Polygon2D : Godot.Polygon2D
{
	private Vector2[] circlePoints;
	private Sprite2D typer;
	private Godot.Sprite2D talksprite;

	public void init()
	{
		Vector2 dimension = talksprite.Texture.GetSize(),
		xy = new Vector2(typer.Position.X, typer.Position.Y);
		int diameter = 24 * typer.ratio,
		margin = 5 * typer.ratio;
		xy.Y += margin;
		xy.X += margin;

		float radius = diameter / 2f;
		
		float scaled = Math.Min(diameter / dimension.X, diameter / dimension.Y);
		Vector2 newsize = new Vector2(dimension.X * scaled, dimension.Y * scaled);
		talksprite.Scale = new Vector2(diameter / dimension.X, diameter / dimension.Y); // multiplier is added to change scale
		//GD.Print("Sprite Scale:", diameter);

		Vector2 offset = new Vector2(radius, radius);
		talksprite.Offset = -offset / typer.ratio;
		// Generate circle points
		int segments = 31; // You can adjust this for smoother or rougher circles
		circlePoints = new Vector2[segments];
		for (int i = 0; i < segments; i++)
		{
			float angle = i * 2 * Mathf.Pi / segments;
			circlePoints[i] = new Vector2(
				xy.X + radius + radius * Mathf.Cos(angle),
				xy.Y + radius + radius * Mathf.Sin(angle)
			);
			//GD.Print(circlePoints[i]);
		}

		//GD.Print("Applied Scale:", scaled);
		talksprite.Position = new Vector2(xy.X + radius/6, xy.Y + radius/16);
		talksprite.Position += new Vector2((diameter - newsize.X) / 2, (diameter - newsize.Y) / 2);
		this.Polygon = circlePoints;
		//this.UV = circlePoints;
	}

	public override void _Ready()
	{
		typer = App.root.GetNode<Sprite2D>("Dialog");
		talksprite = App.root.GetNode<Godot.Sprite2D>("Portrait/Still");
		init();
	}
}
