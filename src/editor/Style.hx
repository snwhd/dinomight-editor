package editor;


enum FontSize {
	Default;
	Small;
	Medium;
	Large;
	XLarge;
}


class Style {

	public static inline var Black    = 0x000000;
	public static inline var White    = 0xFFFFFF;
	public static inline var BarColor = 0x212121;
	public static inline var BackgroundColor = 0x303030;
	public static inline var ForegroundColor = 0x424242;

	public static inline var SelectedColor   = 0x16A34A;
	public static inline var DeselectedColor = 0x3F1D6B;

	public static inline var Padding = 40;
	public static inline var MenuSpacing = 40;

	public static inline var ToolbarWidth   = 400;
	public static inline var ToolbarPadding = 12;
	public static inline var ToolbarCols    = 4;

	public static inline var SidebarWidth = 800;

	public static var fonts : Map<Int, h2d.Font> = [];

	public static function exactFont(size = 0) : h2d.Font {
		if (size == 0) {
			return hxd.res.DefaultFont.get();
		} else if (Style.fonts.exists(size)) {
			return Style.fonts[size];
		} else {
			var font = Style.font(Default).clone();
			font.resizeTo(size);
			Style.fonts[size] = font;
			return font;
		}
	}

	public static function font(size: FontSize) : h2d.Font {
		return switch (size) {
			case Default: Style.exactFont(0);
			case Small:   Style.exactFont(24);
			case Medium:  Style.exactFont(48);
			case Large:   Style.exactFont(96);
			case XLarge:  Style.exactFont(192);
		}
	}

}
