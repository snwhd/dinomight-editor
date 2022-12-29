package editor;

import editor.util.FlowBase;
import editor.util.TextUtil;
import editor.tools.Tool;


class ToolOptions extends FlowBase {

	private var tool : Tool;

	public function new(tool: Tool, parent: FlowBase) {
		super(parent);
		this.tool = tool;

		this.exactWidth = parent.innerWidth;
		this.exactHeight = Std.int((
			parent.innerHeight - parent.verticalSpacing
		) / 2);

		this.layout = Vertical;
		this.verticalAlign = Top;
		this.horizontalAlign = Middle;
		this.verticalSpacing = Style.ToolbarPadding;

		this.drawOptions();
	}

	private function drawOptions() {
		this.removeChildren();
		var spacer = new FlowBase();
		spacer.exactHeight = Style.ToolbarPadding;
		spacer.exactWidth = 1;
		this.addChild(spacer);

		var text = '${this.tool.toolname} options';
		var title = TextUtil.text(text, Medium);
		this.addChild(title);

		var container = new FlowBase(this);
		container.exactWidth = this.innerWidth;
		container.layout = Horizontal;
		container.multiline = true;
		container.overflow = Hidden;
		container.padding = Style.ToolbarPadding;
		container.verticalSpacing = Style.ToolbarPadding;
		container.horizontalSpacing = Style.ToolbarPadding;
		container.colWidth = Style.ToolbarCols;
		container.horizontalAlign = Middle;
		container.verticalAlign = Top;

		for (option in tool.getOptions()) {
			container.addChild(option);
		}
	}

	public function toolChanged(tool: Tool) {
		this.tool = tool;
		this.drawOptions();
	}

}

