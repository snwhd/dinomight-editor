package editor.tools;


class Eraser extends Tool {

	public function new(?parent) {
		super(ToolType.Eraser, parent);
	}

	override function push(x, y, canvas) {
	}

	override function moved(x, y, canvas) {
	}

	override function release(x, y, canvas) {
	}

	override function out(canvas) {
	}

	override function over(isDown, canvas) {
	}


}
