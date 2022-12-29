package editor;

import editor.util.FlowBase;
import editor.util.Random;
import editor.util.ImageUtil;

import editor.tools.Toolbar;


typedef CanvasTile = {
	type: TileType,
	bmp: h2d.Bitmap,
}


class Canvas extends FlowBase {

	public static inline var MIN_WIDTH = 13;
	public static inline var MIN_HEIGHT = 13;
	public static inline var MAX_WIDTH = 100;
	public static inline var MAX_HEIGHT = 100;
	public static inline var MAX_TILES = 20000;

	private static inline var TILE_SIZE = 250;
	private static final TILE_COLORS = [
		0xFFFFBB01,
		0xFFFFD746,
	];

	public static inline var DEFAULT_WIDTH  = 13;
	public static inline var DEFAULT_HEIGHT = 13;

	private var rand : hxd.Rand;

	public var canvasWidth : Int;
	public var canvasHeight : Int;
	private var canvasBackground : h2d.Object;
	public var tiles : Array<Null<CanvasTile>> = [];

	private var iconTiles : Map<TileType, Array<h2d.Tile>>;
	private var iconSize : Int;

	private var toolbar : Toolbar;

	public function new(
		toolbar: Toolbar,
		parent: FlowBase,
		width = DEFAULT_WIDTH,
		height = DEFAULT_HEIGHT
	) : Void {
		super(parent);
		this.toolbar = toolbar;
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
		this.iconTiles = Canvas.loadIconTiles(this.iconSize);

		this.exactHeight = maxIconSize * this.canvasHeight;
		this.exactWidth = maxIconSize * this.canvasWidth;

		this.enableInteractive = true;
		this.interactive.onPush = this.onPush;
		this.interactive.onRelease = this.onRelease;
		this.interactive.onMove = this.onMove;
		this.interactive.onOut = this.onOut;
		this.interactive.onOver = this.onOver;

		this.canvasBackground = this.createBackground();
		this.addChild(this.canvasBackground);

		this.rand = Random.createSafeRand();
		for (x in 0 ... this.canvasWidth) {
			this.put(x, 0, Tree);
			this.put(x, this.canvasHeight - 1, Tree);
		}
		for (y in 0 ... this.canvasHeight) {
			this.put(0, y, Tree);
			this.put(this.canvasWidth - 1, y, Tree);
		}
	}

	public static function loadIconTiles(size: Int) {
		var tiles : Map<TileType, Array<h2d.Tile>> = [
			Block  => [hxd.Res.img.icons.block.toTile()],
			Bomb   => [hxd.Res.img.icons.bomb.toTile()],
			Egg    => [hxd.Res.img.icons.egg.toTile()],
			Meteor => [hxd.Res.img.icons.meteor.toTile()],
			Range  => [hxd.Res.img.icons.range.toTile()],
			Spawn  => [hxd.Res.img.icons.dino.toTile()],
			Speed  => [hxd.Res.img.icons.speed.toTile()],
			Tree   => [
				hxd.Res.img.icons.treeA.toTile(),
				hxd.Res.img.icons.treeB.toTile(),
			],
		];

		for (type => tiles in tiles.keyValueIterator()) {
			for (tile in tiles) {
				ImageUtil.scaleToSquare(tile, size);
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
		if (width > MAX_WIDTH || height > MAX_HEIGHT || width * height > MAX_TILES) {
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

	public function put(x: Int, y: Int, t: Null<TileType>) {
		this.assertInBounds(x, y);
		var index = y * this.canvasWidth + x;

		var existing = this.tile(x, y);
		if (existing != null) {
			existing.bmp.remove();
		}

		if (t == null) {
			this.tiles[index] = null;
			return;
		}

		var tiles = this.iconTiles[t];
		var choice = this.rand.random(tiles.length);

		var bmp = new h2d.Bitmap(tiles[choice], this.canvasBackground);
		bmp.x = x * this.iconSize;
		bmp.y = y * this.iconSize;
		this.tiles[index] = {
			type: t,
			bmp: bmp,
		}
	}

	private function relToTile(e: hxd.Event) : Null<h2d.col.IPoint> {
		var tx = Std.int(e.relX / this.iconSize);
		var ty = Std.int(e.relY / this.iconSize);

		// do not allow editing of the outer ring of trees
		if (tx < 1 || tx >= this.canvasWidth - 1) {
			return null;
		}
		if (ty < 1 || ty >= this.canvasHeight - 1) {
			return null;
		}
		return new h2d.col.IPoint(tx, ty);
	}

	private function onPush(e: hxd.Event) {
		var point = this.relToTile(e);
		if (point != null) {
			var tool = this.toolbar.currentTool;
			tool.onCanvasPush(point.x, point.y, this);
		}
	}

	private function onRelease(e: hxd.Event) {
		var point = this.relToTile(e);
		if (point != null) {
			var tool = this.toolbar.currentTool;
			tool.onCanvasRelease(point.x, point.y, this);
		}
	}

	private function onMove(e: hxd.Event) {
		var point = this.relToTile(e);
		if (point != null) {
			var tool = this.toolbar.currentTool;
			tool.onCanvasMove(point.x, point.y, this);
		}
	}

	private function onOut(e: hxd.Event) {
		var point = this.relToTile(e);
		if (point != null) {
			var tool = this.toolbar.currentTool;
			tool.onCanvasOut(this);
		}
	}

	private function onOver(e: hxd.Event) {
		var point = this.relToTile(e);
		if (point != null) {
			var tool = this.toolbar.currentTool;
			var isDown = false; // TODO
			tool.onCanvasOver(isDown, this);
		}
	}


}
