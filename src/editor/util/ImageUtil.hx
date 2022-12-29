package editor.util;


class ImageUtil {

	public static function scaleToSquare(
		tile: h2d.Tile,
		size: Int
	) : Void {
		// Note: this assumes we are always scaling down
		if (tile.width > tile.height) {
			var ratio = tile.height / tile.width;
			tile.scaleToSize(size, size * ratio);
			var remainder = size - tile.height;
			tile.dy = remainder / 2;
		} else {
			var ratio = tile.width / tile.height;
			tile.scaleToSize(size * ratio, size);
			var remainder = size - tile.width;
			tile.dx = remainder / 2;
		}
	}

}
