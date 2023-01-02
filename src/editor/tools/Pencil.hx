package editor.tools;

import editor.TileType;
import editor.Canvas;


class Pencil extends Tool {

	public var tileType : TileType = Block;
	private var erasing = false;

	private var lastPlaced : Null<h2d.col.IPoint>;

	public function new(?parent) {
		super(ToolType.Pencil, parent);
	}

	private function reset(canvas: Canvas) {
		this.lastPlaced = null;
		this.erasing = false;
		canvas.endGroup();
	}

	private function place(x: Int, y: Int, canvas: Canvas) {
		if (this.erasing) {
			canvas.put(x, y, null);
		} else {
			canvas.put(x, y, this.tileType);
		}
	}

	private function interpolateLineTo(x1: Int, y1: Int, canvas: Canvas) {
		var x0 = this.lastPlaced.x;
		var y0 = this.lastPlaced.y;
		var dx = x1 - x0;
		var dy = y1 - y0;

		var largestDelta = Std.int(Math.abs(dx));
		if (Math.abs(dy) > largestDelta) {
			largestDelta = Std.int(Math.abs(dy));
		}
		var xStep = dx / largestDelta;
		var yStep = dy / largestDelta;

		var x : Float = x0;
		var y : Float = y0;
		for (i in 0 ... largestDelta) {
			x += xStep;
			y += yStep;
			this.place(Math.round(x), Math.round(y), canvas);
		}

		if (x != x1 || y != y1) {
			trace('ERROR: xx != x / yy != y');
			trace('x: $x; x1: $x1; y: $y; y1: $y1');
			trace('last: ${this.lastPlaced}');
			throw 'invalid pencil move';
		}
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
		canvas.beginGroup();
		this.place(x, y, canvas);
		this.lastPlaced = new h2d.col.IPoint(x, y);
	}

	override function rightPush(x, y, canvas: Canvas, delta) {
		this.erasing = true;
		this.push(x, y, canvas, delta);
	}

	override function moved(x, y, canvas: Canvas, delta) {
		if (delta && this.isDown) {
			if (this.lastPlaced != null) {
				this.interpolateLineTo(x, y, canvas);
			} else {
				this.place(x, y, canvas);
			}
			this.lastPlaced = new h2d.col.IPoint(x, y);
		}
		canvas.setShadow(x, y, this.tileType);
	}

	override function release(x, y, canvas: Canvas, delta) {
		this.reset(canvas);
	}

	override function out(canvas: Canvas) {
		this.reset(canvas);
	}

	override function over(leftDown, rightDown, canvas: Canvas) {
		// This should preserve left click or right clicking going in
		// and out of the boundaries of the canvas.
		//
		// In case of both right and left clicking, defaults to left
		// click behavior. Not sure what is expected here (TODO).
		this.lastPlaced = null;
		super.over(leftDown, rightDown, canvas);
		if (!leftDown && rightDown) {
			this.erasing = true;
		}
	}

}
