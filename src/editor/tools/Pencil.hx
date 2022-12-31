package editor.tools;

import editor.TileType;
import editor.Canvas;


class Pencil extends Tool {

	public var tileType : TileType = Block;
	private var lastPlace : Null<h2d.col.IPoint>;
	private var erasing = false;

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
		// TODO: should this be in the if?
		canvas.beginGroup();
		if (delta) {
			if (this.lastPlace != null) {
				var dx = x - this.lastPlace.x;
				var dy = y - this.lastPlace.y;
				var step = Std.int(Math.abs(dx));
				if (Math.abs(dy) > step) {
					step = Std.int(Math.abs(dy));
				}
				var xStep = Std.int(dx / step);
				var yStep = Std.int(dy / step);

				var xx = this.lastPlace.x;
				var yy = this.lastPlace.y;
				for (i in 1 ... step + 1) {
					if (this.erasing) {
						canvas.put(xx, yy, null);
					} else {
						canvas.put(xx, yy, this.tileType);
					}
					xx += xStep;
					yy += yStep;
				}
				if (xx != x || yy != y) {
					trace('ERROR: xx != x / yy != y');
					trace('xx: $xx; x: $x; yy: $yy; y: $y');
					trace('last: ${this.lastPlace}');
					throw 'invalid pencil move';
				}
			} else {
				if (this.erasing) {
					canvas.put(x, y, null);
				} else {
					canvas.put(x, y, this.tileType);
				}
			}
			this.lastPlace = new h2d.col.IPoint(x, y);
		}
	}

	override function rightPush(x, y, canvas: Canvas, delta) {
		this.erasing = true;
		this.push(x, y, canvas, delta);
	}

	override function moved(x, y, canvas: Canvas, delta) {
		if (delta && this.isDown) {
			if (this.erasing) {
				canvas.put(x, y, null);
			} else {
				canvas.put(x, y, this.tileType);
			}
			this.lastPlace = new h2d.col.IPoint(x, y);
		}
		canvas.setShadow(x, y, this.tileType);
	}

	override function release(x, y, canvas: Canvas, delta) {
		this.lastPlace = null;
		this.erasing = false;
		canvas.endGroup();
	}

	override function out(canvas: Canvas) {
		this.lastPlace = null;
		this.erasing = false;
		canvas.endGroup();
	}

	override function over(isDown, canvas: Canvas) {
	}

}
