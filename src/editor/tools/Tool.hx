package editor.tools;

import editor.Canvas;
import editor.util.FlowBase;

class Tool extends FlowBase {

	public var type (default, null) : ToolType;

	// invalid initial position for canvas
	private var lastPosition : h2d.col.IPoint = new h2d.col.IPoint(-1, -1);
	private var deltaOnly = true;
	private var isDown = false;

	public function new(type: ToolType, ?parent) {
		super(parent);
		this.type = type;
		this.enableInteractive = true;
		this.interactive.onClick = function (e) {
			this.onIconClick();
		}
	}

	public function onCanvasPush(
		x: Int,
		y: Int,
		canvas: Canvas
	) : Void {
		trace('tool push');
		this.isDown = true;
		var position = new h2d.col.IPoint(x, y);
		trace(position);
		trace(this.lastPosition);
		trace(this.deltaOnly);
		if (!this.deltaOnly || !position.equals(this.lastPosition)) {
			this.push(x, y, canvas);
		}
		this.lastPosition = position;
	}

	public function onCanvasMove(
		x: Int,
		y: Int,
		canvas: Canvas
	) : Void {
		if (this.isDown) {
			var position = new h2d.col.IPoint(x, y);
			if (!this.deltaOnly || !position.equals(this.lastPosition)) {
				this.moved(x, y, canvas);
			}
			this.lastPosition = position;
		}
	}

	public function onCanvasRelease(
		x: Int,
		y: Int,
		canvas: Canvas
	) : Void {
		this.isDown = false;
		var position = new h2d.col.IPoint(x, y);
		if (!this.deltaOnly || !position.equals(this.lastPosition)) {
			this.release(x, y, canvas);
		}
		this.lastPosition = position;
	}

	public function onCanvasOut(canvas: Canvas) {
		this.isDown = false;
		this.out(canvas);
		this.lastPosition = new h2d.col.IPoint(-1, -1);
	}

	public function onCanvasOver(
		isDown: Bool,
		canvas: Canvas
	) : Void {
		this.isDown = isDown;
		this.over(isDown, canvas);
		// TODO: update lastPosition?
	}

	private function push(x: Int, y: Int, canvas: Canvas) {
	}

	private function moved(x: Int, y: Int, canvas: Canvas) {
	}

	private function release(x: Int, y: Int, canvas: Canvas) {
	}

	private function out(canvas: Canvas) {
	}

	private function over(isDown: Bool, canvas: Canvas) {
	}

	public dynamic function onIconClick() {
	}

}
