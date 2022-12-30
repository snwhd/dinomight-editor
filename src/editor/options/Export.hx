package editor.options;

import editor.Settings;
import editor.util.FlowBase;
import editor.util.TextUtil;


class Export extends Option {

	private var filenameInput : h2d.TextInput;

	public function new(parent: Settings) {
		super('export', parent);
	}

	override function drawUI() {
		super.drawUI();
		var spacing = new FlowBase(this);
		spacing.exactHeight = 1;
		spacing.exactWidth = 20;
		this.filenameInput = TextUtil.input(Medium, this);
		this.filenameInput.text = 'filename';
		this.filenameInput.onChange = function () {
			if (!this.filenameInput.hasFocus() && this.filenameInput.text == '') {
				this.filenameInput.text = 'filename';
			}
		}
		this.filenameInput.onFocusLost = function (e) {
			if (this.filenameInput.text == '') {
				this.filenameInput.text = 'filename';
			}
		}
	}

	override function onClick() {
		var content = this.settings.client.save();
		var filename = '${this.filenameInput.text}.tmj';

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
