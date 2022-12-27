package editor.util;

import editor.Style.FontSize;


class TextUtil {

	public static function text(
		text: String,
		fontSize: FontSize = XLarge
	) : h2d.Text {
		var t = new h2d.Text(Style.font(fontSize));
		t.textColor = 0xFFFFFF;
		t.text = text;
		return t;
	}

}
