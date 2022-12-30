package editor.options;

import editor.Settings;


class Load extends Option {

	public function new(parent: Settings) {
		super('load', parent);
	}

	override function getIcon() {
		return hxd.Res.img.icons.loadOption.toTile();
	}

	override function onClick() {
		this.settings.client.displayAutosaves();
	}

}
