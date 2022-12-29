package editor.options;

import editor.Settings;
import editor.util.FlowBase;
import editor.util.TextUtil;


class Option extends FlowBase {

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
			this.backgroundColor = Style.DeselectedColor;
		}
		this.interactive.onOut = function (e) {
			this.backgroundColor = Style.DeselectedColor;
		}
	}

	public function drawUI() {
		this.layout = Horizontal;
		this.verticalAlign = Middle;
		this.horizontalAlign = Middle;

		this.exactWidth = Std.int(this.flowParent.innerWidth * 0.5);
		this.backgroundColor = Style.DeselectedColor;
		var text = TextUtil.text(this.optionname, Medium);
		text.textColor = Style.White;
		this.addChild(text);
	}

	private function onClick() {
	}

}
