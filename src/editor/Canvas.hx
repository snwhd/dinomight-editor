package editor;

import editor.util.FlowBase;


typedef CanvasTile = {
	type: TileType,
	bmp: h2d.Bitmap,
}


class Canvas extends FlowBase {

	public static inline var MIN_WIDTH = 13;
	public static inline var MIN_HEIGHT = 13;
	public static inline var MAX_TILES = 20000;

	private static inline var TILE_SIZE = 250;
	private static final TILE_COLORS = [
		0xFFFFBB01,
		0xFFFFD746,
	];

	private static inline var DEFAULT_WIDTH  = 13;
	private static inline var DEFAULT_HEIGHT = 13;

	private var canvasWidth : Int;
	private var canvasHeight : Int;
	private var canvasBackground : h2d.Object;
	private var tiles : Array<Null<CanvasTile>> = [];

	private var iconTiles : Map<TileType, h2d.Tile>;
	private var iconSize : Int;

	public function new(
		parent: FlowBase,
		width = DEFAULT_WIDTH,
		height = DEFAULT_HEIGHT
	) : Void {
		super(parent);
		this.assertValidSize(width, height);

		// increase for the outer ring of trees
		this.canvasHeight = height + 2;
		this.canvasWidth = width + 2;

		this.tiles.resize(this.canvasWidth * this.canvasHeight);

		var maxWidth = parent.innerWidth;
		var maxHeight = parent.innerHeight;
		var maxFlowSize = Std.int(Math.min(maxWidth, maxHeight));

		var maxIconWidth = maxFlowSize / this.canvasWidth;
		var maxIconHeight = maxFlowSize / this.canvasHeight;
		var maxIconSize = Std.int(Math.min(maxIconWidth, maxIconHeight));

		this.iconSize = maxIconSize;
		this.iconTiles = this.loadIconTiles(this.iconSize);
		// TODO: draw trees

		this.exactHeight = maxIconSize * this.canvasHeight;
		this.exactWidth = maxIconSize * this.canvasWidth;

		this.enableInteractive = true;
		this.interactive.onClick = this.onClick;

		this.canvasBackground = this.createBackground();
		this.addChild(this.canvasBackground);
	}

	private function loadIconTiles(size: Int) {
		var tiles : Map<TileType, h2d.Tile> = [
			Egg => hxd.Res.img.icons.egg.toTile(),
		];

		for (type => tile in tiles.keyValueIterator()) {
			// scale down tiles to fit in the grid
			// Note: this assumes we are always scaling down, which is
			//       likely the case unless on a really high res monitor
			trace('tile size: ${tile.width} x ${tile.height}');
			if (tile.width > tile.height) {
				var ratio = tile.height / tile.width;
				tile.scaleToSize(size, size * ratio);
				var yRemainder = size - tile.height;
				tile.dy = yRemainder / 2;
			} else {
				var ratio = tile.width / tile.height;
				tile.scaleToSize(size * ratio, size);
				var xRemainder = size - tile.width;
				tile.dx = xRemainder / 2;
			}
		}
		return tiles;
	}

	private function createBackground() : h2d.Object {
		var pixels = hxd.Pixels.alloc(
			this.canvasWidth,
			this.canvasHeight,
			BGRA
		);
		for (x in 0 ... this.canvasWidth) for (y in 0 ... this.canvasHeight) {
			var color = TILE_COLORS[(x + y) % 2];
			pixels.setPixel(x, y, color);
		}
		var bmp = new h2d.Bitmap(h2d.Tile.fromPixels(pixels));
		// setting height should auto-scale width, TODO: confirm
		bmp.height = this.exactHeight;
		bmp.width = this.exactWidth;
		return bmp;
	}

	private function assertValidSize(width: Int, height:Int) {
		if (width < MIN_WIDTH || height < MIN_HEIGHT) {
			throw 'map too small';
		}
		if (width * height > MAX_TILES) {
			throw 'map too big';
		}
	}

	private function assertInBounds(x: Int, y: Int) {
		if (x < 0 || x >= this.canvasWidth) {
			throw 'oob';
		}
		if (y < 0 || y >= this.canvasHeight) {
			throw 'oob';
		}
	}
	
	public function tile(x: Int, y: Int) : CanvasTile {
		this.assertInBounds(x, y);
		var index = y * this.canvasWidth + x;
		return this.tiles[index];
	}

	public function put(x: Int, y: Int, t: TileType) {
		this.assertInBounds(x, y);
		var index = y * this.canvasWidth + x;

		var existing = this.tile(x, y);
		if (existing != null) {
			existing.bmp.remove();
		}

		var bmp = new h2d.Bitmap(this.iconTiles[t], this.canvasBackground);
		// var bmp = new h2d.Bitmap(h2d.Tile.fromColor(0xff0000, this.iconSize, this.iconSize), this.canvasBackground);
		bmp.x = x * this.iconSize;
		bmp.y = y * this.iconSize;
		this.tiles[index] = {
			type: t,
			bmp: bmp,
		}
	}

	private function onClick(e: hxd.Event) {
		var tx = Std.int(e.relX / this.iconSize);
		var ty = Std.int(e.relY / this.iconSize);

		// do not allow editing of the outer ring of trees
		if (tx < 1 || tx >= this.canvasWidth - 2) {
			return;
		}
		if (ty < 1 || ty >= this.canvasHeight - 2) {
			return;
		}

		// TODO: use tool
		this.put(tx, ty, Egg);
	}

}
