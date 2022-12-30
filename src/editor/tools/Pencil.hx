package editor.tools;

import editor.TileType;


class Pencil extends Tool {

	// TODO: load from palette
	private var tileType : TileType = Tree;

	public function new(?parent) {
		super(ToolType.Pencil, parent);
	}

	override function getIcon() {
		return hxd.Res.img.icons.pencilTool.toTile();
	}

	override function getOptions() {
		return this.paletteOptions();
	}

	override function paletteSelect(tile) {
		this.tileType = tile;
	}

	override function push(x, y, canvas, delta) {
		if (delta) {
			canvas.put(x, y, this.tileType);
		}
	}

	override function moved(x, y, canvas, delta) {
		if (delta && this.isDown) {
			canvas.put(x, y, this.tileType);
		}
		canvas.setShadow(x, y, this.tileType);
	}

	override function release(x, y, canvas, delta) {
	}

	override function out(canvas) {
	}

	override function over(isDown, canvas) {
	}

}
