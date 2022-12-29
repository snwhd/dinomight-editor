package editor.util;

import editor.Style.FontSize;


class TextUtil {

	public static function text(
		text: String,
		fontSize: FontSize = XLarge,
		?parent
	) : h2d.Text {
		var t = new h2d.Text(Style.font(fontSize), parent);
		t.textColor = 0xFFFFFF;
		t.text = text;
		return t;
	}

	public static function input(
		fontSize: FontSize = XLarge,
		?parent
	) : h2d.TextInput {
		var t = new h2d.TextInput(Style.font(fontSize), parent);
		t.textColor = Style.Blue;
		return t;
	}

}
