package editor.tools;

import editor.Canvas;
import editor.Style;
import editor.TileType;
import editor.util.FlowBase;
import editor.util.TextUtil;
import editor.util.ImageUtil;

class Tool extends FlowBase {

	public static final TOOL_NAMES : Map<ToolType, String> = [
		Cursor    => "cursor",
		Pencil    => "pencil",
		Fill      => "fill",
		Eraser    => "eraser",
		BoxSelect => "select",
		Wand      => "wand",
	];

	public var type (default, null) : ToolType;
	public var toolname (default, null) : String;

	// invalid initial position for canvas
	private var lastDownPosition : h2d.col.IPoint = new h2d.col.IPoint(-1, -1);
	private var isDown = false;

	private var selectedPalette : FlowBase = null;

	public function new(type: ToolType, ?parent) {
		super(parent);
		this.type = type;
		this.toolname = TOOL_NAMES[type];
		this.drawUI();

		this.enableInteractive = true;
		this.interactive.onClick = function (e) {
			this.onIconClick();
		}
		this.interactive.cursor = Button;
	}

	private function drawUI() {
		this.verticalAlign = Middle;
		this.horizontalAlign = Middle;
		this.padding = Std.int(Style.IconPadding);
		var tile = this.getIcon();
		tile.scaleToSize(Style.IconSize, Style.IconSize);
		new h2d.Bitmap(tile, this);
	}

	private function getIcon() : h2d.Tile {
		throw 'must override';
	}

	public function select() {
		this.backgroundColor = Style.SelectedColor;
	}

	public function deselect() {
		this.backgroundColor = null;
	}

	public function getOptions() : Array<FlowBase> {
		return [];
	}

	public function paletteOptions(?selected: TileType) : Array<FlowBase> {
		if (selected == null) {
			selected = Block;
		}
		var tilesMap = Canvas.loadIconTiles(Style.IconSize);
		var flows = [];
		var tileOrder : Array<TileType> = [
			Block,
			Egg,
			Spawn,
			Tree,
			Meteor,
			Bomb,
			Range,
			Speed,
		];
		for (type in tileOrder) {
			var tiles = tilesMap[type];
			var tile = tiles[0];
			var flow = new FlowBase();
            flow.padding = Style.IconPadding;
            flow.exactWidth = Style.IconSize + 2*Style.IconPadding;
            flow.exactHeight= Style.IconSize + 2*Style.IconPadding;
			flow.verticalAlign = Middle;
			flow.horizontalAlign = Middle;
			flow.enableInteractive = true;
			flow.interactive.onClick = function(e) {
				if (this.selectedPalette != null) {
					this.selectedPalette.backgroundColor = null;
				}
				this.paletteSelect(type);
				this.selectedPalette = flow;
				this.selectedPalette.backgroundColor = Style.SelectedColor;
			}
			flow.interactive.cursor = Button;
			var bmp = new h2d.Bitmap(tile, flow);
			if (type == selected) {
				// highlight selected option to start
				flow.interactive.onClick(null);
			}

			flows.push(flow);
		}
		// flows[0].interactive.onClick(null);
		return flows;
	}

	private function paletteSelect(tile: TileType) {
	}

	public function onCanvasPush(
		x: Int,
		y: Int,
		canvas: Canvas
	) : Void {
		this.isDown = true;
		var position = new h2d.col.IPoint(x, y);
		var delta = !position.equals(this.lastDownPosition);
		this.push(x, y, canvas, delta);
		this.lastDownPosition = position;
	}

	public function onCanvasRightPush(
		x: Int,
		y: Int,
		canvas: Canvas
	) : Void {
		this.isDown = true;
		var position = new h2d.col.IPoint(x, y);
		var delta = !position.equals(this.lastDownPosition);
		this.rightPush(x, y, canvas, delta);
		this.lastDownPosition = position;
	}

	public function onCanvasMove(
		x: Int,
		y: Int,
		canvas: Canvas
	) : Void {
		var position = new h2d.col.IPoint(x, y);
		var delta = !position.equals(this.lastDownPosition);
		this.moved(x, y, canvas, delta);
		if (this.isDown) {
			this.lastDownPosition = position;
		}
	}

	public function onCanvasRelease(
		x: Int,
		y: Int,
		canvas: Canvas
	) : Void {
		this.isDown = false;
		var position = new h2d.col.IPoint(x, y);
		var delta = !position.equals(this.lastDownPosition);
		this.release(x, y, canvas, delta);
		this.lastDownPosition = position;
	}

	public function onCanvasOut(canvas: Canvas) {
		this.isDown = false;
		this.out(canvas);
		this.lastDownPosition = new h2d.col.IPoint(-1, -1);
	}

	public function onCanvasOver(
		leftDown: Bool,
		rightDown: Bool,
		canvas: Canvas
	) : Void {
		this.over(leftDown, rightDown, canvas);
		// TODO: update lastDownPosition?
	}

	private function push(x: Int, y: Int, canvas: Canvas, delta: Bool) {
	}

	private function rightPush(x: Int, y: Int, canvas: Canvas, delta: Bool) {
		this.push(x, y, canvas, delta);
	}

	private function moved(x: Int, y: Int, canvas: Canvas, delta: Bool) {
	}

	private function release(x: Int, y: Int, canvas: Canvas, delta: Bool) {
	}

	private function out(canvas: Canvas) {
	}

	private function over(leftDown: Bool, rightDown: Bool, canvas: Canvas) {
		this.isDown = leftDown || rightDown;
	}

	public dynamic function onIconClick() {
	}

}
