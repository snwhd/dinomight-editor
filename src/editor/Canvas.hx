package editor;


class Canvas {

	private static inline var TILE_SIZE = 250;
	private static final TILE_COLORS = [
		0xFFBB01,
		0xFFD746,
	];

	private static inline var DEFAULT_WIDTH  = 13;
	private static inline var DEFAULT_HEIGHT = 13;

	private var width: Int;
	private var height: Int;
	private var tiles: Array<TileType> = [];

	public function new(
		width = DEFAULT_WIDTH,
		height = DEFAULT_HEIGHT
	) : Void {
		this.assertValidSize(width, height);
		this.tiles.resize(width * height);
		this.height = height;
		this.width = width;
	}

	private function assertValidSize(width: Int, height:Int) {
		if (width < 13 || height < 13) {
			throw 'map too small';
		}
		if (width * height > 20000) {
			throw 'map too big';
		}
	}

	private function assertInBounds(x: Int, y: Int) {
		if (x < 0 || x >= this.width) {
			throw 'oob';
		}
		if (y < 0 || y >= this.height) {
			throw 'oob';
		}
	}
	
	public function tile(x: Int, y: Int) {
		this.assertInBounds(x, y);
		var index = y * this.width + x;
		return this.tiles[index];
	}

	public function put(x: Int, y: Int, t: TileType) {
		this.assertInBounds(x, y);
		var index = y * this.width + x;
		this.tiles[index] = t;
	}

}
