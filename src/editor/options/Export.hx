package editor.options;

import editor.Settings;


class Export extends Option {

	public function new(parent: Settings) {
		super('export', parent);
	}

	override function onClick() {
		trace('saving');
	}

}
