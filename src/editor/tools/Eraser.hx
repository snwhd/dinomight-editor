package editor.tools;

import editor.Canvas;

class Eraser extends Tool {

	public function new(?parent) {
		super(ToolType.Eraser, parent);
	}

	override function getIcon() {
		return hxd.Res.img.icons.eraserTool.toTile();
	}

	override function push(x, y, canvas: Canvas, delta) {
		if (delta) {
			canvas.put(x, y, null);
		}
	}

	override function moved(x, y, canvas: Canvas, delta) {
		if (delta && this.isDown) {
			canvas.put(x, y, null);
		}
	}

	override function release(x, y, canvas: Canvas, delta) {
	}

	override function out(canvas: Canvas) {
	}

	// override function over(leftDown, rightDown, canvas: Canvas) {
	// }


}
