package editor.options;

import editor.Settings;
import editor.util.FlowBase;
import editor.util.TextUtil;


class Option extends FlowBase {

	public static inline var ICON_SIZE = 128;

	private var optionname : String;
	private var settings : Settings;

	public function new(name: String, parent: Settings) {
		super(parent);
		this.settings = parent;
		this.optionname = name;
		this.enableInteractive = true;
		this.interactive.onClick = function (e) {
			this.onClick();
		}
		this.interactive.onPush = function(e) {
			this.backgroundColor = Style.SelectedColor;
		}
		this.interactive.onRelease = function (e) {
			this.backgroundColor = null; // Style.DeselectedColor;
		}
		this.interactive.onOut = function (e) {
			this.backgroundColor = null; // Style.DeselectedColor;
		}
	}

	public function drawUI() {
		this.layout = Vertical;
		this.verticalAlign = Middle;
		this.horizontalAlign = Middle;
		this.padding = 12;

		// this.exactWidth = Std.int(this.flowParent.innerWidth * 0.75);
		// this.backgroundColor = Style.DeselectedColor;
		this.padding = 12;

		var tile = this.getIcon();
		tile.scaleToSize(ICON_SIZE, ICON_SIZE);
		new h2d.Bitmap(tile, this);

		// var text = TextUtil.text(this.optionname, Medium);
		// text.textColor = Style.White;
		// this.addChild(text);
	}

	private function getIcon() : h2d.Tile {
		throw 'must override';
	}

	private function onClick() {
	}

}
