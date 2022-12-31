package editor;

import editor.util.FlowBase;
import editor.util.Random;
import editor.util.ImageUtil;

import editor.tools.Toolbar;


typedef CanvasTile = {
	type: TileType,
	bmp: h2d.Bitmap,
}


enum Action {
	Put(x: Int, y: Int, t: Null<TileType>, p: Null<TileType>);
}


class Canvas extends FlowBase {

	public static inline var MIN_WIDTH = 13;
	public static inline var MIN_HEIGHT = 13;
	public static inline var MAX_WIDTH = 100;
	public static inline var MAX_HEIGHT = 100;
	public static inline var MAX_TILES = 20000;

	public static inline var HISTORY_LENGTH = 100;
	private var history : Array<Array<Action>> = [];
	private var future : Array<Array<Action>> = [];
	private var grouping = false;

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

	private var shadow : h2d.Flow;

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
			this.put(x, 0, Tree, true);
			this.put(x, this.canvasHeight - 1, Tree, true);
		}
		for (y in 0 ... this.canvasHeight) {
			this.put(0, y, Tree, true);
			this.put(this.canvasWidth - 1, y, Tree, true);
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

	public function isInBounds(x: Int, y: Int, ?excludeBorder=false) {
		if (x < 0 || x >= this.canvasWidth) {
			return false;
		}
		if (y < 0 || y >= this.canvasHeight) {
			return false;
		}

		if (excludeBorder) {
			if (x < 1 || x >= this.canvasWidth - 1) {
				return false;
			}
			if (y < 1 || y >= this.canvasHeight - 1) {
				return false;
			}
		}

		return true;
	}

	private function assertInBounds(x: Int, y: Int) {
		if (!this.isInBounds(x, y)) {
			throw 'oob';
		}
	}
	
	public function tile(x: Int, y: Int) : CanvasTile {
		this.assertInBounds(x, y);
		var index = y * this.canvasWidth + x;
		return this.tiles[index];
	}

	public function put(x: Int, y: Int, t: Null<TileType>, ?undo=false) {
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

		if (!undo) {
			var prev = if (existing == null) null else existing.type;
			appendAction(Put(x, y, t, prev));
		}
	}

	public function removeShadow() {
		this.shadow.remove();
		this.shadow = null;
	}

	public function setShadow(x: Int, y: Int, t: Null<TileType>) {
		if (!this.isInBounds(x, y)) {
			this.removeShadow();
			return;
		}

		var tile = this.iconTiles[t][0];
		if (this.shadow == null) {
			this.shadow = new h2d.Flow(this.canvasBackground);
			this.shadow.verticalAlign = Top;
			this.shadow.horizontalAlign = Left;
			this.shadow.minHeight = this.iconSize;
			this.shadow.minWidth = this.iconSize;
			this.shadow.overflow = Hidden;
			this.shadow.backgroundTile = h2d.Tile.fromColor(0x268bd2);
			this.shadow.alpha = 0.5;
		}
		this.shadow.removeChildren();
		this.shadow.x = x * this.iconSize;
		this.shadow.y = y * this.iconSize;
		new h2d.Bitmap(tile, this.shadow);
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
		} else {
			this.removeShadow();
		}
	}

	private function onOut(e: hxd.Event) {
		var point = this.relToTile(e);
		if (point != null) {
			var tool = this.toolbar.currentTool;
			tool.onCanvasOut(this);
		}
		this.removeShadow();
	}

	private function onOver(e: hxd.Event) {
		var point = this.relToTile(e);
		if (point != null) {
			var tool = this.toolbar.currentTool;
			var isDown = false; // TODO
			tool.onCanvasOver(isDown, this);
		}
	}

	//
	// undo/redo
	//

	public function undo() {
		if (this.history.length > 0) {
			var actions = this.history.pop();
			this.future.push(actions);
			for (action in actions) {
				switch (action) {
					case Put(x, y, t, p):
						this.put(x, y, p, true);
				}
			}
		}
	}

	public function redo() {
		if (this.future.length > 0) {
			var actions = this.future.pop();
			this.history.push(actions);
			for (action in actions) {
				switch (action) {
					case Put(x, y, t, p):
						this.put(x, y, t, true);
				}
			}
		}
	}

	public function beginGroup() {
		this.grouping = true;
		this.history.push([]);
		this.trimHistory();
	}

	public function endGroup() {
		this.grouping = false;
		var group = this.history.pop();
		if (group.length > 0) {
			this.history.push(group);
		}
	}

	private function appendAction(action: Action) {
		this.future = [];
		if (this.grouping) {
			var group = this.history[this.history.length - 1];
			group.push(action);
		} else {
			this.history.push([action]);
		}
		this.trimHistory();
	}

	private function trimHistory() {
		if (this.history.length > HISTORY_LENGTH) {
			this.history.shift();
		}
	}

}
