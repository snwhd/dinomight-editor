package editor.tools;

import editor.Canvas;


class BoxSelect extends Tool {

	public function new(?parent) {
		super(ToolType.BoxSelect, parent);
	}

	override function push(x, y, canvas: Canvas, delta) {
	}

	override function moved(x, y, canvas: Canvas, delta) {
	}

	override function release(x, y, canvas: Canvas, delta) {
	}

	override function out(canvas: Canvas) {
	}

	override function over(leftDown, rightDown, canvas: Canvas) {
	}


}
