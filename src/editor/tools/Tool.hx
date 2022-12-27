package editor.tools;

import editor.Canvas;
import editor.util.FlowBase;
import editor.util.TextUtil;

class Tool extends FlowBase {

	public static final TOOL_NAMES : Map<ToolType, String> = [
		Cursor    => "cursor",
		Brush     => "brush",
		Fill      => "fill",
		Eraser    => "eraser",
		BoxSelect => "select",
		Wand      => "wand",
	];

	public var type (default, null) : ToolType;
	public var toolname (default, null) : String;

	// invalid initial position for canvas
	private var lastPosition : h2d.col.IPoint = new h2d.col.IPoint(-1, -1);
	private var deltaOnly = true;
	private var isDown = false;

	public function new(type: ToolType, ?parent) {
		super(parent);
		this.type = type;
		this.toolname = TOOL_NAMES[type];
		this.drawUI();

		this.enableInteractive = true;
		this.interactive.onClick = function (e) {
			this.onIconClick();
		}
	}

	private function drawUI() {
		this.layout = Horizontal;
		this.verticalAlign = Middle;
		this.horizontalAlign = Middle;

		this.exactWidth = Std.int(this.flowParent.innerWidth);
		// this.exactHeight = this.exactWidth;
		this.backgroundColor = Style.DeselectedColor;
		var text = TextUtil.text(this.toolname, Large);
		text.textColor = Style.White;
		this.addChild(text);
	}

	public function select() {
		this.backgroundColor = Style.SelectedColor;
	}

	public function deselect() {
		this.backgroundColor = Style.DeselectedColor;
	}

	public function onCanvasPush(
		x: Int,
		y: Int,
		canvas: Canvas
	) : Void {
		this.isDown = true;
		var position = new h2d.col.IPoint(x, y);
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
