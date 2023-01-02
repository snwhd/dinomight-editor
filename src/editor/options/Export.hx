package editor.options;

import editor.Settings;
import editor.util.FlowBase;
import editor.util.TextUtil;


class Export extends Option {

	public function new(parent: Settings) {
		super('export', parent);
	}

	override function getIcon() {
		return hxd.Res.img.icons.saveOption.toTile();
	}

	override function onClick() {
		var content = this.settings.client.save();
		// TODO: preserve filename from open?
		var filename = 'dinomight_map.tmj';

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
