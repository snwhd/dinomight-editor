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

	public function export(filename: String) {
		var baseText = hxd.Res.loader.load('baseJson.json').toText();
		var layerText = hxd.Res.loader.load('layerJson.json').toText();
		var base = haxe.Json.parse(baseText);
		var layer = haxe.Json.parse(layerText);
		base.width = this.canvas.canvasWidth;
		base.height = this.canvas.canvasHeight;
		layer.width = this.canvas.canvasWidth;
		layer.height = this.canvas.canvasHeight;
		var data : Array<Int> = [];
		for (tile in this.canvas.tiles) {
			if (tile == null) {
				data.push(0);
			} else {
				data.push(switch(tile.type) {
					case Block:  3;
					case Bomb:   7;
					case Egg:    5;
					case Meteor: 6;
					case Range:  8;
					case Spawn:  1;
					case Speed:  9;
					case Tree:   4;
					case null:   0;
				});
			}
		}
		layer.data = data;
		base.layers = [layer];
		var content = haxe.Json.stringify(base);
		var filename = '$filename.tmj';

		#if js
		var a = js.Browser.document.createAnchorElement();
		var blob = new js.html.Blob(
			[haxe.io.Bytes.ofString(content).getData()],
			{type:'application/json'}
		);
		var url = js.html.URL.createObjectURL(blob);
		a.href = url;
		a.download = filename;
		js.Browser.document.body.appendChild(a);
		a.click();
		js.Browser.window.setTimeout(function() {
			js.Browser.document.body.removeChild(a);
			js.html.URL.revokeObjectURL(url);
		}, 0);
		#end
	}

}
