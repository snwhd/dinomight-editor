package editor;

import editor.TileType;

import editor.util.FlowBase;
import editor.util.TextUtil;
import editor.tools.Tool;
import editor.tools.Pencil;
import editor.tools.Fill;


class ToolOptions extends FlowBase {

	private var tool : Tool;
	private var previousPalette : Null<TileType>;
	private var optionContainer : FlowBase;

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

		this.optionContainer = container;
	}


	public function number(option: Int) {
		// TODO: restrict to Pencil/Fill?
		var children = this.optionContainer.children;
		if (option < children.length) {
			try {
				var child : FlowBase = cast(children[option]);
				child.interactive.onClick(null);
			} catch (e) {
			}
		}
	}

	private function preservePalette() {
		// TODO: just move tileType into Tool?
		switch (Type.getClass(this.tool)) {
			case Pencil:
				var p : Pencil = cast(this.tool);
				this.previousPalette = p.tileType;
			case Fill:
				var f : Fill = cast(this.tool);
				this.previousPalette = f.tileType;
			case _: // do not preserve
		}
	}

	private function restorePalette() {
		if (this.previousPalette != null) switch (Type.getClass(this.tool)) {
			case Pencil:
				var p : Pencil = cast(this.tool);
				p.tileType = this.previousPalette;
			case Fill:
				var f : Fill = cast(this.tool);
				f.tileType = this.previousPalette;
			case _: // do not restore 
		}
	}

	public function toolChanged(tool: Tool) {
		this.preservePalette();
		this.tool = tool;
		this.restorePalette();
		this.drawOptions();
	}

}

