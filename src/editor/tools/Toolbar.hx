package editor.tools;

import editor.util.FlowBase;


class Toolbar extends FlowBase {

	private var tools : Array<Tool>;

	private var currentIndex = 0;
	public var currentTool (get, never) : Tool;

	public function new(parent: h2d.Flow) {
		super(parent);

		switch (parent.layout) {
			case Vertical:
				// mobile
				this.layout = Horizontal;
				this.horizontalSpacing = Style.MenuSpacing;
				this.verticalAlign = Middle;
				this.horizontalAlign = Left;

				this.exactWidth = this.flowParent.innerWidth;
				this.exactHeight = Style.ToolbarWidth;
			case Horizontal:
				this.layout = Vertical;
				this.verticalSpacing = Style.MenuSpacing;
				this.horizontalAlign = Middle;
				this.verticalAlign = Top;

				this.exactHeight = this.flowParent.innerHeight;
				this.exactWidth = Style.ToolbarWidth;
			case layout:
				throw 'invalid layout: $layout';
		}

		this.padding = Style.Padding;

		this.tools = [
			new Pencil(this),
			new Eraser(this),
			new Fill(this),
			// new BoxSelect(this),
			// new Wand(this),
			// new Cursor(this),
		];
		this.currentTool.select();

		for (tool in this.tools) {
			this.addChild(tool);
			tool.onIconClick = function () {
				this.select(tool.type);
			}
		}
	}

	public function get_currentTool() {
		return this.tools[this.currentIndex];
	}

	public function next() {
		this.currentTool.deselect();
		this.currentIndex = (this.currentIndex + 1) % this.tools.length;
		this.onToolChanged(this.currentTool);
		this.currentTool.select();
	}

	public function prev() {
		this.currentTool.deselect();
		this.currentIndex = (
			this.currentIndex + this.tools.length - 1
		) % this.tools.length;
		this.onToolChanged(this.currentTool);
		this.currentTool.select();
	}

	public function select(type: ToolType) : Bool {
		for (i => tool in this.tools.keyValueIterator()) {
			if (tool.type == type) {
				this.currentTool.deselect();
				this.currentIndex = i;
				this.onToolChanged(this.currentTool);
				this.currentTool.select();
				return true;
			}
		}
		return false;
	}

	public dynamic function onToolChanged(tool: Tool) {
	}

}
