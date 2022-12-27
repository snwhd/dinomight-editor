package editor;

import editor.tools.Toolbar;
import editor.util.FlowBase;


class Client extends hxd.App {

	private var flow : h2d.Flow;
	private var toolbar : Toolbar;
	private var canvas : FlowBase;
	private var toolOptions : FlowBase;
	private var settings : FlowBase;
	

	static function main() {
		new Client();
	}

	override function init() {
		hxd.Res.initEmbed();
		//TODO: hxd.Window.getInstance().addEventTarget(onEvent);
		this.makeUI();
	}

	public function makeUI() {
		this.flow = this.makeFlow();

		this.toolbar = new Toolbar(this.flow);
		this.toolbar.exactHeight = this.flow.innerHeight;
		this.toolbar.exactWidth = Style.ToolbarWidth;

		// this.canvas = new Canvas(this.flow);
		var canvasContainer = new FlowBase(this.flow);
		var maxWidth = this.flow.innerWidth - (
			Style.Padding * 2  +
			Style.ToolbarWidth +
			Style.SidebarWidth
		);
		canvasContainer.exactHeight = this.flow.innerHeight;
		canvasContainer.exactWidth = maxWidth;
		canvasContainer.layout = Vertical;
		canvasContainer.verticalAlign = Middle;
		canvasContainer.horizontalAlign = Middle;
		canvasContainer.backgroundColor = Style.BackgroundColor;

		this.canvas = new FlowBase(canvasContainer);
		var canvasSize = Std.int(Math.min(
			this.flow.innerHeight * 0.95,
			maxWidth
		));
		this.canvas.exactHeight = canvasSize;
		this.canvas.exactWidth = canvasSize;

		// this.canvas.exactHeight = Std.int(this.flow.innerHeight * 0.85);
		// this.canvas.exactWidth = this.flow.innerWidth - (
		// 	Style.Padding * 2  +
		// 	Style.ToolbarWidth +
		// 	Style.SidebarWidth
		// );

		var sidebar = new FlowBase(this.flow);
		sidebar.layout = Vertical;
		sidebar.verticalSpacing = Style.Padding;
		sidebar.exactHeight = this.flow.innerHeight;
		sidebar.exactWidth = Style.SidebarWidth;
		sidebar.backgroundColor = Style.BackgroundColor;

		this.toolOptions = new FlowBase(sidebar);
		this.toolOptions.exactWidth = Style.SidebarWidth;
		this.toolOptions.exactHeight = Std.int((
			sidebar.innerHeight - sidebar.verticalSpacing
		) / 2);

		this.settings = new FlowBase(sidebar);
		this.settings.exactWidth = Style.SidebarWidth;
		this.settings.exactHeight = Std.int((
			sidebar.innerHeight - sidebar.verticalSpacing
		) / 2);


		//TODO: this.editor = this.makeEditor(this.flow);
	}

	private function makeFlow() {
		var flow = new h2d.Flow(this.s2d);
		flow.backgroundTile = h2d.Tile.fromColor(Style.BackgroundColor);

		flow.layout = Horizontal;
		flow.padding = Style.Padding;
		flow.horizontalSpacing = Style.Padding;

		flow.horizontalAlign = Left;
		flow.verticalAlign = Middle;

		flow.fillHeight = true;
		flow.fillWidth = true;
		return flow;
	}

	// private function makeEditor(parent) : Editor {
	// }

	override function update(dt: Float) {
	}

}
