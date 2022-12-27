package editor.tools;

import editor.util.FlowBase;


class Toolbar extends FlowBase {

	private var tools : Array<Tool> = [
		// new Cursor(),
		new Brush(),
		// new Fill(),
		// new Eraser(),
		// new BoxSelect(),
		// new Wand(),
	];

	private var currentIndex = 0;
	public var currentTool (get, never) : Tool;

	public function new(?parent) {
		super(parent);
		for (tool in this.tools) {
			tool.onIconClick = function () {
				this.select(tool.type);
			}
		}
	}

	public function get_currentTool() {
		return this.tools[this.currentIndex];
	}

	public function next() {
		this.currentIndex = (this.currentIndex + 1) % this.tools.length;
		this.onToolChanged(this.currentTool);
	}

	public function prev() {
		this.currentIndex = (
			this.currentIndex + this.tools.length - 1
		) % this.tools.length;
		this.onToolChanged(this.currentTool);
	}

	public function select(type: ToolType) : Bool {
		for (i => tool in this.tools.keyValueIterator()) {
			if (tool.type == type) {
				this.currentIndex = i;
				this.onToolChanged(this.currentTool);
				return true;
			}
		}
		return false;
	}

	public dynamic function onToolChanged(tool: Tool) {
	}

}
