using Godot;
using System;

public partial class Label : Godot.Label
{
	public LabelSettings style;
	public int factor = 3;
	private Sprite2D chatbox;
	private const int minSize = 8;
	private VBoxContainer parent;
	public void init()
	{
		Vector2 cord = new Vector2(0,0);
		int outline = factor-1;
		style.FontSize = minSize*factor;
		style.LineSpacing = style.FontSize/2;
		style.OutlineSize = (minSize*outline)-outline;
		style.ShadowSize = (int) Math.Round(style.OutlineSize/2f);
		style.ShadowOffset = new Vector2(style.ShadowSize/2,style.ShadowSize/2);
		float sum = style.FontSize+style.LineSpacing+style.OutlineSize;
		parent.SetDeferred("custom_minimum_size", this.Size);
		parent.ForceUpdateTransform();
		parent.PivotOffset = (parent.Position  - parent.Size) / 2;
		cord.X = (App.size.X - parent.Size.X) / 2;
		cord.Y =  App.size.Y - (chatbox.textureSize.Y/3.25f + sum);
		parent.Position = cord;
	}
	public override void _Ready()
	{
		style = this.LabelSettings;
		parent = this.GetParent<VBoxContainer>();
		chatbox = App.root.GetNode<Sprite2D>("Dialog");
		init();
	}
}
