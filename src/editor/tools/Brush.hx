package editor.tools;

import editor.TileType;


class Brush extends Tool {

	// TODO: load from palette
	private var tileType : TileType = Tree;

	public function new(?parent) {
		super(ToolType.Brush, parent);
	}

	override function push(x, y, canvas) {
		trace('brush push');
		canvas.put(x, y, this.tileType);
	}

	override function moved(x, y, canvas) {
		if (this.isDown) {
			canvas.put(x, y, this.tileType);
		}
	}

	override function release(x, y, canvas) {
	}

	override function out(canvas) {
	}

	override function over(isDown, canvas) {
	}

}
