package editor;

import editor.util.FlowBase;


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

	private var canvasWidth: Int;
	private var canvasHeight: Int;
	private var tiles: Array<TileType> = [];

	private var iconSize : Int;

	public function new(
		parent: FlowBase,
		width = DEFAULT_WIDTH,
		height = DEFAULT_HEIGHT
	) : Void {
		super(parent);
		this.assertValidSize(width, height);

		this.tiles.resize(width * height);
		this.canvasHeight = height + 2;
		this.canvasWidth = width + 2;

		var maxWidth = parent.innerWidth;
		var maxHeight = parent.innerHeight;
		var maxFlowSize = Std.int(Math.min(maxWidth, maxHeight));

		var maxIconWidth = maxFlowSize / this.canvasWidth;
		var maxIconHeight = maxFlowSize / this.canvasHeight;
		var maxIconSize = Std.int(Math.min(maxIconWidth, maxIconHeight));

		this.iconSize = maxIconSize;
		this.exactHeight = maxIconSize * this.canvasHeight;
		this.exactWidth = maxIconSize * this.canvasWidth;

		this.enableInteractive = true;
		this.interactive.onClick = this.onClick;

		this.addChild(this.createBackground());
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
	
	public function tile(x: Int, y: Int) {
		this.assertInBounds(x, y);
		var index = y * this.canvasWidth + x;
		return this.tiles[index];
	}

	public function put(x: Int, y: Int, t: TileType) {
		this.assertInBounds(x, y);
		var index = y * this.canvasWidth + x;
		this.tiles[index] = t;
	}

	private function onClick(e: hxd.Event) {
		var tx = Std.int(e.relX / this.iconSize);
		var ty = Std.int(e.relY / this.iconSize);
		trace('($tx, $ty)');
	}

}
