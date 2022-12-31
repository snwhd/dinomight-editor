package editor.tools;

import editor.Canvas;


class Cursor extends Tool {

	public function new(?parent) {
		super(ToolType.Cursor, parent);
	}

	override function push(x, y, canvas: Canvas, delta) {
	}

	override function moved(x, y, canvas: Canvas, delta) {
	}

	override function release(x, y, canvas: Canvas, delta) {
	}

	override function out(canvas: Canvas) {
	}

	override function over(isDown, canvas: Canvas) {
	}


}
