package editor.options;

import editor.Settings;
import editor.util.FlowBase;
import editor.util.TextUtil;


class New extends Option {

	private var heightInput : h2d.TextInput;
	private var widthInput : h2d.TextInput;

	public function new(parent: Settings) {
		super('new', parent);
	}

	override function getIcon() {
		return hxd.Res.img.icons.newOption.toTile();
	}

	override function drawUI() {
		super.drawUI();
		var spacing = new FlowBase(this);
		spacing.exactHeight = 1;
		spacing.exactWidth = 20;

		var sizeContainer = new FlowBase(this);
		sizeContainer.layout = Horizontal;
		sizeContainer.verticalAlign = Middle;
		sizeContainer.horizontalAlign = Middle;
		sizeContainer.backgroundColor = null;

		this.widthInput = TextUtil.input(Medium, sizeContainer);
		this.widthInput.text = '13';
		this.widthInput.onChange = function () {
			if (!this.widthInput.hasFocus() && this.widthInput.text == '') {
				this.widthInput.text = '13';
			}
		}
		this.widthInput.onFocusLost = function (e) {
			if (this.widthInput.text == '') {
				this.widthInput.text = '13';
			}
		}
		var x = TextUtil.text('x', Small, sizeContainer);
		this.heightInput = TextUtil.input(Medium, sizeContainer);
		this.heightInput.text = '13';
		this.heightInput.onChange = function () {
			if (!this.heightInput.hasFocus() && this.heightInput.text == '') {
				this.heightInput.text = '13';
			}
		}
		this.heightInput.onFocusLost = function (e) {
			if (this.heightInput.text == '') {
				this.heightInput.text = '13';
			}
		}
	}

	override function onClick() {
		var width = Std.parseInt(this.widthInput.text);
		if (width == null || width < 13 || width > 100) {
			#if js
			js.Browser.alert('invalid width (min 13, max 100)');
			#end
			return;
		}
		var height = Std.parseInt(this.heightInput.text);
		if (height == null || height < 13 || height > 100) {
			#if js
			js.Browser.alert('invalid height (min 13, max 100)');
			#end
			return;
		}

		if (width * height > Canvas.MAX_TILES) {
			#if js
			js.Browser.alert('invalid size (max 20k tiles)');
			#end
			return;
		}

		this.settings.client.newMap(width, height);
	}

}
