package editor.tools;


class Fill extends Tool {

	// overridden within paletteOptions()
	public var tileType : TileType = Block;

	public function new(?parent) {
		super(ToolType.Fill, parent);
	}

	override function getIcon() {
		return hxd.Res.img.icons.fillTool.toTile();
	}

	override function getOptions() {
		return this.paletteOptions(this.tileType);
	}

	override function paletteSelect(tile) {
		this.tileType = tile;
	}

	override function push(x, y, canvas, delta) {
	}

	override function moved(x, y, canvas, delta) {
			canvas.setShadow(x, y, this.tileType);
	}

	override function release(x, y, canvas, delta) {
		this.doFill(x, y, this.tileType, canvas);
	}

	override function out(canvas) {
	}

	override function over(isDown, canvas) {
	}

	private function doFill(
		x: Int,
		y: Int,
		t: Null<TileType>,
		c: Canvas
	) : Void {
		var visited : Map<h2d.col.IPoint, Bool> = [];
		var current = new h2d.col.IPoint(x, y);
		var todo : Array<h2d.col.IPoint> = [
			current,
		];

		var tile = c.tile(x, y);
		var overwrite : Null<TileType> = if (tile == null) null else tile.type;

		if (overwrite == t) {
			return;
		}

		while (todo.length > 0) {
			var next = todo.pop();
			if (visited.exists(next)) {
				continue;
			}

			var tile = c.tile(next.x, next.y);
			var type = if (tile == null) null else tile.type;
			if (type != overwrite) {
				continue;
			}

			c.put(next.x, next.y, t);

			for (x in -1 ... 2) for (y in -1 ... 2) {
				if (x == 0 || y == 0) { // TODO: diag
					var near = new h2d.col.IPoint(next.x + x, next.y + y);
					if (
						!visited.exists(near) &&
						!todo.contains(near)  &&
						c.isInBounds(near.x, near.y)
					) {
						todo.push(near);
					}
				}
			}
		}
	}
}
