package editor.tools;

import editor.util.FlowBase;
import editor.util.UIUtil;


class Toolbar extends FlowBase {

	private var tools : Array<Tool>;

	private var currentIndex = 0;
	public var currentTool (get, never) : Tool;

	public function new(parent: h2d.Flow) {
		super(parent);

		this.padding = Style.Padding;
		switch (Style.Layout) {
            case Horizontal:
                UIUtil.initVbox(this);
				this.exactHeight = this.flowParent.innerHeight;
			case Vertical:
                UIUtil.initHbox(this);
				this.verticalAlign = Middle;
				this.exactWidth = this.flowParent.innerWidth;
		}

		this.tools = [
			new Pencil(this),
			new Eraser(this),
			new Fill(this),
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
