package editor.tools;

import editor.TileType;
import editor.Canvas;


class Pencil extends Tool {

	public var tileType : TileType = Block;

	public function new(?parent) {
		super(ToolType.Pencil, parent);
	}

	override function getIcon() {
		return hxd.Res.img.icons.pencilTool.toTile();
	}

	override function getOptions() {
		return this.paletteOptions(tileType);
	}

	override function paletteSelect(tile) {
		this.tileType = tile;
	}

	override function push(x, y, canvas: Canvas, delta) {
		if (delta) {
			canvas.put(x, y, this.tileType);
		}
	}

	override function moved(x, y, canvas: Canvas, delta) {
		if (delta && this.isDown) {
			canvas.put(x, y, this.tileType);
		}
		canvas.setShadow(x, y, this.tileType);
	}

	override function release(x, y, canvas: Canvas, delta) {
	}

	override function out(canvas: Canvas) {
	}

	override function over(isDown, canvas: Canvas) {
	}

}
