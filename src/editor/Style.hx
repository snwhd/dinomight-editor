package editor;


enum FontSize {
	Default;
	Small;
	Medium;
	Large;
	XLarge;
}


enum UILayout {
    Horizontal;
    Vertical;
}


class Style {

	public static inline var Black = 0x000000;
	public static inline var White = 0xFFFFFF;
	public static inline var Blue  = 0xA0A0FF;
	public static inline var BarColor = 0x212121;
	// public static inline var BackgroundColor = 0x303030;
	// public static inline var ForegroundColor = 0x424242;
	public static inline var BackgroundColor = 0x404040;
	public static inline var ForegroundColor = 0x525252;

	public static inline var SelectedColor   = 0x16A34A;
	public static inline var DeselectedColor = 0x3F1D6B;

	public static inline var InputColor = 0xFFFFFF;

	public static inline var SidebarWidth = 168;

	public static var fonts : Map<Int, h2d.Font> = [];
    public static var fontSizes : Map<FontSize, Int>= [];

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
        return Style.exactFont(Style.fontSizes[size]);
	}


    // TODO: delete
	public static inline var ToolbarCols    = 4;

    public static var Layout : UILayout = Horizontal;

	private static var BaseIconPadding = 16;
	public static var IconPadding = 16;

	private static var BaseIconSize = 48;
	public static var IconSize = 32;

	public static inline var Padding = 32;
	public static inline var Spacing = 16;
    public static inline var MenuSpacing = 8;

    // toolbar
    private static var RelToolbarSize = 0.10;
    public static var ToolbarSize = 0;

    // sidebar
    private static var RelSidebarSize = 0.25;
    public static var SidebarSize = 0;

    public static function resize(width: Int, height: Int) {
        var multiply : Int = 1;
        if (height <= width) {
            Style.Layout = Horizontal;
            Style.ToolbarSize = Std.int(Style.RelToolbarSize * width);
            Style.SidebarSize = Std.int(Style.RelSidebarSize * width);
            multiply = Std.int(width / 1200);
        } else {
            Style.Layout = Vertical;
            Style.ToolbarSize = Std.int(Style.RelToolbarSize * height);
            Style.SidebarSize = Std.int(Style.RelSidebarSize * height);
            multiply = Std.int(height / 800); // TODO 800?
        }

        if (multiply < 1) {
            multiply = 1;
        }

        Style.IconPadding = Style.BaseIconPadding * multiply;
        Style.IconSize = Style.BaseIconSize * multiply;
        // TODO: spacing and padding?

        Style.fontSizes = [
		    Default =>  0,
			Small   => 12 * multiply,
			Medium  => 24 * multiply,
			Large   => 48 * multiply,
			XLarge  => 96 * multiply,
        ];

    }

}
