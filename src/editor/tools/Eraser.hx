package editor.tools;


class Eraser extends Tool {

	public function new(?parent) {
		super(ToolType.Eraser, parent);
	}

	override function getIcon() {
		return hxd.Res.img.icons.eraserTool.toTile();
	}

	override function push(x, y, canvas) {
		canvas.put(x, y, null);
	}

	override function moved(x, y, canvas) {
		if (this.isDown) {
			canvas.put(x, y, null);
		}
	}

	override function release(x, y, canvas) {
	}

	override function out(canvas) {
	}

	override function over(isDown, canvas) {
	}


}
