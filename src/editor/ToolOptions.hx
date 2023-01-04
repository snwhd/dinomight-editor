package editor;

import editor.TileType;
import editor.Style;

import editor.util.FlowBase;
import editor.util.TextUtil;
import editor.util.UIUtil;
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

		switch (Style.Layout) {
			case Horizontal:
                UIUtil.initVbox(this);
				this.horizontalAlign = Middle;
				this.verticalSpacing = Style.Spacing;
				this.exactWidth = parent.innerWidth;
				this.exactHeight = Std.int((
					parent.innerHeight - parent.verticalSpacing
				) / 2);
			case Vertical:
				UIUtil.initVbox(this);
				this.horizontalAlign = Middle;
				this.verticalSpacing = Style.Spacing;
				this.exactHeight = parent.innerHeight;
				this.exactWidth = Std.int((
					parent.innerWidth - parent.horizontalSpacing
				) / 2);
		}

		this.drawOptions();
	}

	private function drawOptions() {
		this.removeChildren();

		var container = new FlowBase(this);
		container.exactWidth = this.innerWidth;
		container.layout = Horizontal;
		container.multiline = true;
		container.horizontalAlign = Middle;
		container.verticalAlign = Top;
		container.verticalSpacing = Style.MenuSpacing;
		container.horizontalSpacing = Style.MenuSpacing;
        container.overflow = Scroll;

        var childWidth : Int = 0;
		for (option in tool.getOptions()) {
			container.addChild(option);
            childWidth = container.outerWidth;
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

