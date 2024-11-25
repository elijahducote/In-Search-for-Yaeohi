using Godot;
using System;

public partial class Sprite2D : Godot.Sprite2D
{
	public Vector2 dimensions,
	textureSize;
	public int ratio = 6;
	private Vector2 origin = new Vector2(0,0);
	private Label text;
	private Vector2 RelativeChange(Vector2 initial, Vector2 current) {
		float relativeX = (current.X - initial.X) / initial.X,
		relativeY = (current.Y - initial.Y) / initial.Y;
		relativeX *= 100;
		relativeY *= 100;
		return new Vector2(relativeX,relativeY);
	}
	public void init(bool modality)
	{
		Vector2 rateOChange = RelativeChange(App.span,this.GetViewport().GetVisibleRect().Size);
		float appliedScale = dimensions.X * ratio,
		aspectRatio = dimensions.X / dimensions.Y,
		newWidth = appliedScale;
		int factorHz = (int) Math.Round(newWidth / dimensions.X),
		factorVt = (int) Math.Round((newWidth / aspectRatio) / dimensions.Y);
		//this.Size = new Vector2(newWidth,(newWidth / aspectRatio));
		textureSize = new Vector2((int)Math.Round(newWidth),(int)Math.Round(newWidth / aspectRatio));
		//GD.Print("AspectRatio",aspectRatio);
		//this.Offset = textureSize/2;
		//this.PivotOffset = this.Size/2;
		//origin.X = (App.size.X - this.Size.X) / 2;
		//origin.Y = (App.size.Y - this.Size.Y) / 2;
		origin.X = (App.size.X - textureSize.X) / 2;
		origin.Y = App.size.Y - textureSize.Y;
		
		if (modality) {
			if (rateOChange.X == 0 || rateOChange.Y == 0) {
				ratio = 6;
				text.factor = 3;
			}
		}
		else {
			if (rateOChange.X < -48 || rateOChange.Y < -48) {
				ratio = 4;
				text.factor = 2;
			}
		}
		//else origin.Y -= (.125f * App.size.Y) * factorVt;
		this.Position = origin;
		///this.CustomMinimumSize = this.Size;
		this.Scale = new Vector2(factorHz,factorVt);
	}
	public override void _Ready()
	{
		text = App.root.GetNode<Label>("Container/Message");
		//StyleBox panel = this.GetThemeStylebox("panel");
		dimensions = this.Texture.GetSize();
		init(true);
		//if (panel is StyleBoxTexture styleBoxTexture)
		//{
		//	dimensions = new Vector2(this.Texture.GetWidth(),styleBoxTexture.Texture.GetHeight());
		//	init(true);
		//}
	}
}
