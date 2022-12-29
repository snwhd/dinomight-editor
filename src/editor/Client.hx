package editor;

import editor.tools.Toolbar;
import editor.util.FlowBase;


class Client extends hxd.App {

	private var flow : h2d.Flow;
	private var toolbar : Toolbar;
	private var canvas : Canvas;
	private var toolOptions : ToolOptions;

	private var settings : FlowBase;

	private var canvasWidth = Canvas.DEFAULT_WIDTH;
	private var canvasHeight = Canvas.DEFAULT_HEIGHT;
	

	static function main() {
		new Client();
	}

	override function init() {
		hxd.Res.initEmbed();
		//TODO: hxd.Window.getInstance().addEventTarget(onEvent);
		this.makeUI();
	}

	public function makeUI() {
		this.s2d.removeChildren();
		this.flow = this.makeFlow();

		this.toolbar = new Toolbar(this.flow);

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

		this.canvas = new Canvas(
			this.toolbar,
			canvasContainer,
			this.canvasWidth,
			this.canvasHeight
		);

		var sidebar = new FlowBase(this.flow);
		sidebar.layout = Vertical;
		sidebar.verticalSpacing = Style.Padding;
		sidebar.exactHeight = this.flow.innerHeight;
		sidebar.exactWidth = Style.SidebarWidth;
		sidebar.backgroundColor = Style.BackgroundColor;

		this.toolOptions = new ToolOptions(this.toolbar.currentTool, sidebar);
		this.toolbar.onToolChanged = function (tool) {
			this.toolOptions.toolChanged(tool);
		};

		this.settings = new Settings(this, sidebar);
		this.settings.exactWidth = Style.SidebarWidth;
		this.settings.exactHeight = Std.int((
			sidebar.innerHeight - sidebar.verticalSpacing
		) / 2);
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

	public function newMap(width: Int, height: Int) {
		this.canvasWidth = width;
		this.canvasHeight = height;
		this.makeUI();
	}

}
