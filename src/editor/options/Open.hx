package editor.options;

import editor.Settings;


class Open extends Option {

	public function new(parent: Settings) {
		super('open', parent);
	}

	override function getIcon() {
		return hxd.Res.img.icons.openOption.toTile();
	}

	override function onClick() {
		#if js
		var i = js.Browser.document.createInputElement();
		i.type = 'file';
		i.onchange = function(e) {
			var file = e.target.files[0];
			if (file == null) return;

			var reader = new js.html.FileReader();
			reader.readAsText(file, 'UTF-8');
			reader.onload = function(e) {
				var content = haxe.Json.parse(e.target.result);
				this.settings.client.load(content);
			};
		};
		i.click();
		#end
	}

}
